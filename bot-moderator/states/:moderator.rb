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

def publishing_in_channel complaint, usernameOfChannelByUserbot
    main_bot = Telegram::Bot::Client.new(ENV['TOKEN_MAIN'])

    scammer = User.find_by(telegram_id:complaint.telegram_id)

    res = main_bot.api.send_message(text:Text.publication_in_channel(complaint, scammer, usernameOfChannelByUserbot), chat_id:ENV['TELEGRAM_CHANNEL_ID'], parse_mode:"HTML")
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

def getUsernameOfChannelByUserbot scammer_data
    result = ''
    
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
    

        usernameOfChannelByUserbot = ''

        scammer = User.find_by(telegram_id:complaint.telegram_id)
        scammer_data = scammer.username
        scammer_data = "@#{scammer_data}" if !scammer_data.nil?
        scammer_data ||= scammer.telegram_id
        main_bot = Telegram::Bot::Client.new(ENV['TOKEN_MAIN'])

        begin
            usernameOfChannelByUserbot = getUsernameOfChannelByUserbot(scammer_data)
            
            Send.mes(usernameOfChannelByUserbot, to: ENV['CHAT_ID_MY']) if usernameOfChannelByUserbot.include?('Error')


            voices = complaint.media_data["voice_file_ids"]
            videos = complaint.media_data["video_note_file_ids"]
            option_texts = complaint.media_data["texts"]

            if videos.any? || voices.any?
                answer = ""
                answer << "Содержание жалобы"
                answer << "\n#{complaint.complaint_text}"
                answer << "\n"
                if option_texts.any?
                    answer << "\nДополнительные комментарии"
                    option_texts.each {|text| answer << "\n#{text}"}
                end
                main_bot.api.send_message(chat_id:"@#{usernameOfChannelByUserbot}", text:answer)

                if videos.any?
                    videos.each do |video_file_id|
                        main_bot.api.sendVideoNote(chat_id:"@#{usernameOfChannelByUserbot}", video_note:video_file_id)
                    end
                end
                if voices.any?
                    voices.each do |voice_file_id|
                        main_bot.api.sendVoice(chat_id:"@#{usernameOfChannelByUserbot}", voice:voice_file_id)
                    end
                end
            end
        rescue => exception
            text =  "scammer_data = #{scammer_data}"
            text << "\nusernameOfChannelByUserbot = #{usernameOfChannelByUserbot}"
            text << "\nfrom userbot on created channel scammer_id=#{scammer.id} complaint_id=#{complaint.id} #{exception}"
            Send.mes(text, to: ENV['CHAT_ID_MY'])
            Send.mes(exception.backtrace, to: ENV['CHAT_ID_MY'])            
        end


        publishing_in_channel(complaint, usernameOfChannelByUserbot)
        update_black_list_user_whith_scamer_status(complaint)
        Send.mes(Text.handle_accept_complaint(complaint))
        main_bot.api.send_message(
            text:Text.complaint_published(complaint),
            chat_id:complaint.user.telegram_id,
            parse_mode:"HTML"
        )
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