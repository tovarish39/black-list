class StateMachine
    class_eval do
      include AASM
      aasm do
        state :moderator
  
        event :moderator_action, from: :moderator do
          transitions if: -> { mes_text?('/start') }                , after: :greeting_mod           , to: :moderator

          transitions if: -> { mes_text?(Button.active_complaints) }, after: :view_complaints        , to: :moderator

          transitions if: -> { mes_data?(/accept_complaint/) && actual_user_status_and_complaint_status?()}       , after: :handle_accept_complaint, to: :moderator
          transitions if: -> { mes_data?(/reject_complaint/) && actual_user_status_and_complaint_status?()}       , after: :handle_reject_complaint, to: :explanation
          transitions if: -> { mes_data?(/reject_complaint/) || mes_data?(/accept_complaint/)}                    , after: :already_handled, to: :moderator

          transitions if: -> { mes_data?(/access_justification/) }  , after: :accessing_justification, to: :moderator
          transitions if: -> { mes_data?(/block_user/) }            , after: :blocking_scamer        , to: :moderator
        end
      end
    end
  end
  
  def greeting_mod
    Send.mes(Text.greeting_mod, M::Reply.greeting_mod)
end

def already_handled
    Send.mes(Text.was_handled)
end


# request_to_moderator     not_scamer или verified
# если определено было админинстратором, то сбрасываются статус претензий

def actual_user_status_and_complaint_status?
    complaint = get_complaint_by_button()
    raise 'complaint not found by button' if complaint.nil?

    is_actual_complaint_status = complaint.status == 'request_to_moderator'
    return false if !is_actual_complaint_status

    actual_user_statuses = [
        'not_scamer:default',
        'not_scamer:managed_by_admin',
        'not_scamer:managed_by_moderator',
        'verified:managed_by_admin',
        'trusted:managed_by_admin', 
        'dwc:managed_by_admin', 
    ]
    is_actual_user_status = actual_user_statuses.include?(User.find_by(telegram_id:complaint.telegram_id).status)
    return false if !is_actual_user_status

    true
end

def actual_complaint? complaint
    actual_complaint_status = complaint.status == 'request_to_moderator' 
    return false if !actual_complaint_status

    actual_user_statuses = ['not_scamer:default','not_scamer:managed_by_admin','not_scamer:managed_by_moderator','verified:managed_by_admin']
    actual_user_status = actual_user_statuses.include?(User.find_by(telegram_id:complaint.telegram_id).status)
    return false if !actual_user_status

    true
end

def actual_complaints
    Complaint.all.filter {|complaint| actual_complaint?(complaint)} 
end

def users_whith_actual_justifications
    User.where.not(justification: nil).select { |user| actual_scamer?(user) }
end

def actual_scamer?(user)
    user.justification.present? && (user.status =~ /^scamer/) && !(user.status =~ /blocked/)
end

def view_complaints
    complaints_to_moderator = actual_complaints() # request_to_moderator     not_scamer или verified
    userTo_justifications = users_whith_actual_justifications()

    date_time_now = DateTime.now.strftime('%d.%m.%Y %H:%M')
    Send.mes(Text.date_time_now(date_time_now))


    complaints_to_moderator.each do |complaint|
        userFrom = complaint.user
        userTo = User.find_by(telegram_id:complaint.telegram_id)
        # puts userFrom, userTo
        Send.mes(
            Text.moderator_complaint(userFrom, userTo, complaint), 
            M::Inline.moderator_complaint(complaint),
        )
    end
    userTo_justifications.each do |userTo|
        accepted_complaints = Complaint.where(telegram_id:userTo.telegram_id).filter {|complaint| complaint.status == 'accepted_complaint'}
        
        Send.mes(
            Text.justification_request_to_moderator(accepted_complaints, userTo),
            M::Inline.justification_request_to_moderator(userTo)
        )
    end

    Send.mes(Text.not_complaints) if complaints_to_moderator.empty? && userTo_justifications.empty?
end

def publishing_in_channel complaint, invite_link_data
    main_bot = Telegram::Bot::Client.new(ENV['TOKEN_MAIN'])

    scammer = User.find_by(telegram_id:complaint.telegram_id)

    res = main_bot.api.send_message(text:Text.publication_in_channel(complaint, scammer, invite_link_data), chat_id:ENV['TELEGRAM_CHANNEL_ID'], parse_mode:"HTML")
    complaint.update(mes_id_published_in_channel:res['result']['message_id'])
end

def get_complaint_by_button
    complaint_id = $mes.data.split("/").first
    complaint = Complaint.find_by(id:complaint_id)
end

def update_black_list_user_whith_scamer_status complaint
    user = User.find_by(telegram_id:complaint.telegram_id)
    user.update!(
        status:'scamer:managed_by_moderator',
        date_when_became_a_scamer:DateTime.now
    )
end

def getInvite_link_data scammer_data
    # result = ''
    
    # Create a TCP socket
    hostname = 'localhost'
    port = 3400
    
    socket = TCPSocket.open(hostname, port)
    
    # Send a string to Python
    string_to_send = "/user_data/#{scammer_data}"
    socket.puts(string_to_send)
    
    # Receive the response from Python
    socket.close_write # Without this line, the next line hangs
    result = socket.read
    
    # Close the socket
    socket.close

    result
end

def reset_amount_sended_messages amount_messages
    amount_messages = 0
    sleep 60
end


def handle_accept_complaint
    complaint = get_complaint_by_button()
    return if complaint.nil?

    if  actual_complaint?(complaint)
        
        $user.access_amount = $user.access_amount + 1
        $user.decisions_per_day_amount = $user.decisions_per_day_amount + 1
        $user.save


        complaint.update(
            status:'accepted_complaint',
            handled_moderator_id:$user.id
        )
        notify_message = Send.mes(Text.loading_requiest)


        limit_messages = 20
        amount_messages = 0


        invite_link_data = ''

        scammer = User.find_by(telegram_id:complaint.telegram_id)
        scammer_data = scammer.username
        scammer_data = "@#{scammer_data}" if !scammer_data.nil?
        scammer_data ||= scammer.telegram_id
        main_bot = Telegram::Bot::Client.new(ENV['TOKEN_MAIN'])

        begin
            voices = complaint.media_data["voice_file_ids"]
            videos = complaint.media_data["video_note_file_ids"]
            option_texts = complaint.media_data["texts"]
            photos = complaint.photo_file_ids

            if voices.any? || voices.any?

                response = getInvite_link_data(scammer_data)
                invite_link_data = JSON.parse(response)
                sleep 1 # так как бывает что бот ещё не успел стать участником канала
                if invite_link_data['result'] === 'error'
                    Send.mes(invite_link_data, to: ENV['CHAT_ID_MY']) 
                elsif  invite_link_data['result'] === 'success'

                    channel_telegram_id = invite_link_data['telegram_id']
# основной текст жалобы
                    answer = complaint.complaint_text
                    answer << "\n"
# дополнительные тексты
                    if option_texts.any?
                        option_texts.each {|text| answer << "\n#{text}"}
                    end
                    main_bot.api.send_message(chat_id:channel_telegram_id, text:answer)
                    amount_messages += 1
# скрины                     
                    if photos.any?
                        photos.each do |photo_file_id|
                            main_bot.api.sendPhoto(chat_id:channel_telegram_id, photo:photo_file_id)
                            amount_messages += 1
                            reset_amount_sended_messages(amount_messages) unless amount_messages < limit_messages
                        end
                    end
# кружки - видео
# sleep 2 # 
                    if videos.any?
                        videos.each do |video_file_id|
                            main_bot.api.sendVideoNote(chat_id:channel_telegram_id, video_note:video_file_id)
                            amount_messages += 1
                            reset_amount_sended_messages(amount_messages) unless amount_messages < limit_messages
                        end
                    end
# голосовые сообщения
                    if voices.any?
                        voices.each do |voice_file_id|
                            main_bot.api.sendVoice(chat_id:channel_telegram_id, voice:voice_file_id)
                            amount_messages += 1
                            reset_amount_sended_messages(amount_messages) unless amount_messages < limit_messages
                        end
                     end
# какой-то одинаковый текст
                            
                    main_bot.api.send_message(chat_id:channel_telegram_id, text:Text.private_channel_post_text, parse_mode:"HTML")
                    amount_messages += 1
                    reset_amount_sended_messages(amount_messages) unless amount_messages < limit_messages
# если добавляли видео боту через команду /config channel-videl, то видео
                    config = Config.first
                    if config 
                        last_video = config.for_private_channel_video_file_ids.last
                        if last_video
                            main_bot.api.sendVideo(chat_id:channel_telegram_id, video:last_video, caption:Text.private_channel_post_video_caption, parse_mode:"HTML")
                        end
                    end
                end
            end
        rescue => exception
            text =  "<b>scammer_data =</b> #{scammer_data}"
            text << "\n<b>invite_link_data =</b> #{invite_link_data}"
            text << "\n<b>from userbot on created channel scammer_id =</b>#{scammer.id} <b>complaint_id =</b>#{complaint.id} #{exception}"
            Send.mes(text, to: ENV['CHAT_ID_MY'])
            # Send.mes(exception.backtrace, to: ENV['CHAT_ID_MY'])            
        end

        
        publishing_in_channel(complaint, invite_link_data)
        update_black_list_user_whith_scamer_status(complaint)
        Send.mes(Text.handle_accept_complaint(complaint))
        main_bot.api.send_message(
            text:Text.complaint_published(complaint),
            chat_id:complaint.user.telegram_id,
            parse_mode:"HTML"
        )
        $bot.api.delete_message(chat_id:$mes.message.chat.id, message_id:notify_message['result']['message_id'])
    else
        Send.mes(Text.was_handled)
    end
end

def is_already_handled? 
    complaint = get_complaint_by_button()
    return if complaint.nil?
    # puts complaint.status 
    complaint.status != "request_to_moderator"
end

def handle_reject_complaint
    complaint = get_complaint_by_button()
    return if complaint.nil?

    if  actual_complaint?(complaint)
        $user.reject_amount = $user.reject_amount + 1
        $user.decisions_per_day_amount = $user.decisions_per_day_amount + 1
        $user.save



        complaint.update!(
            status:'rejected_complaint',
            handled_moderator_id:$user.id
        )
        $user.update(cur_complaint_id:complaint.id)
        Send.mes(Text.input_cause_of_reject)
    else
        Send.mes(Text.was_handled)
    end
end

def get_scamer_by_button
    scamer_id = $mes.data.split("/").first
    scamer = User.find(scamer_id)
end

def send_notify_to user, text
    main_bot = Telegram::Bot::Client.new(ENV['TOKEN_MAIN'])
    main_bot.api.send_message(
        chat_id:user.telegram_id,
        text:text,
        parse_mode:'HTML'
    )
end

def user_is_scamer_now? user
    user.status.split(':').first === 'scamer'
end


def accessing_justification
    scamer = get_scamer_by_button()

    if actual_scamer?(scamer)

        $user.access_amount = $user.access_amount + 1
        $user.decisions_per_day_amount = $user.decisions_per_day_amount + 1
        $user.save

        accessed_complaints = Complaint.where(telegram_id:scamer.telegram_id).where(status:'accepted_complaint')

        if (accessed_complaints.any?) # есть жалобы # нет жалоб. изменено администратором
            accessed_complaints.update_all(status:"rejected_complaint")
        end

            scamer.update!(
                status:'not_scamer:managed_by_moderator',
                state_aasm:'start',
                justification:nil
            )

            clear_user = scamer
            Send.mes(Text.accessing_justification)
            send_notify_to(clear_user, Text.you_not_scamer(scamer))

    else
        already_handled
    end
end

def blocking_scamer
    scamer = get_scamer_by_button()

    if actual_scamer?(scamer)
        $user.block_amount = $user.block_amount + 1
        $user.decisions_per_day_amount = $user.decisions_per_day_amount + 1
        $user.save

        complaint = Complaint.where(telegram_id:scamer.telegram_id).find_by(status:'accepted_complaint')

        scamer.update!(status:'scamer:blocked_by_moderator')
        Send.mes(Text.blocking_user)
        send_notify_to(scamer, Text.you_blocked(complaint, scamer))
    else
        already_handled
    end
end