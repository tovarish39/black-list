# frozen_string_literal: true

class StateMachine
  class_eval do
    include AASM
    aasm do
      state :moderator

      event :moderator_action, from: :moderator do
        transitions if: -> { mes_text?('/start') }, after: :greeting_mod, to: :moderator
        # кнопка "Активные заявки"
        transitions if: -> { mes_text?(Button.active_complaints) }, after: :view_complaints, to: :moderator
        # одобрение complaint
        transitions if: lambda {
                          mes_data?(/accept_complaint/) && actual_user_status_and_complaint_status?
                        }, after: :handle_accept_complaint, to: :moderator
        # отклонение complain
        transitions if: lambda {
                          mes_data?(/reject_complaint/) && actual_user_status_and_complaint_status?
                        }, after: :handle_reject_complaint, to: :explanation
        # не валидный статус у complaint - не "request_to_moderator" или у userTo статус - "^scamer"
        transitions if: lambda {
                          mes_data?(/reject_complaint/) || mes_data?(/accept_complaint/)
                        }, after: :already_handled, to: :moderator
        # принятие оправдание скамера
        transitions if: -> { mes_data?(/access_justification/) }, after: :accessing_justification, to: :moderator
        # отклонение оправдание скамера
        transitions if: -> { mes_data?(/block_user/) }, after: :blocking_scamer, to: :moderator
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

def actual_user_status_and_complaint_status? # rubocop:disable Metrics/MethodLength
  complaint = get_complaint_by_button
  raise 'complaint not found by button' if complaint.nil?

  return false unless actual_complaint?(complaint)

  # актуальные все, кроме :suspect статуса, который делает модератор

  userTo = if complaint.telegram_id.present?
             User.find_by(telegram_id: complaint.telegram_id)
           else
             User.find_by(username: complaint.username)
           end
  return true if userTo.nil?

  is_actual_user_status = userTo.status != 'suspect'
  return false unless is_actual_user_status

  true
end

def actual_complaint?(complaint)
  complaint.status == 'request_to_moderator'
end

# def actual_complaint? complaint
#     actual_complaint_status = complaint.status == 'request_to_moderator'
#     return false if !actual_complaint_status

#     # actual_user_statuses = ['not_scamer:default','not_scamer:managed_by_admin','not_scamer:managed_by_moderator','verified:managed_by_admin']

#     actual_user_statuses = [
#         'not_scamer:default',
#         'not_scamer:managed_by_admin',
#         'not_scamer:managed_by_moderator',
#         'verified:managed_by_admin',
#         'trusted:managed_by_admin',
#         'dwc:managed_by_admin',
#     ]

#     userTo = if complaint.telegram_id.present?
#                  User.find_by(telegram_id:complaint.telegram_id)
#              else
#                  User.find_by(username:complaint.username)
#              end

#     actual_user_status = actual_user_statuses.include?(userTo.status)
#     return false if !actual_user_status
#     true
# end

def actual_complaints
  Complaint.all.filter { |complaint| actual_complaint?(complaint) }
end

def users_whith_actual_justifications
  User.where.not(justification: nil).select { |user| actual_scamer?(user) }
end

def actual_scamer?(user)
  user.justification.present? && (user.status =~ /^scamer/) && !(user.status =~ /blocked/)
end

def view_complaints # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength
  complaints_to_moderator = actual_complaints # request_to_moderator     not_scamer или verified

  userTo_justifications = users_whith_actual_justifications

  date_time_now = DateTime.now.strftime('%d %b %Y %H:%M')
  Send.mes(Text.date_time_now(date_time_now))

  complaints_to_moderator.each do |complaint|
    userFrom = complaint.user
    userTo = User.find_by(telegram_id: complaint.telegram_id)
    userTo ||= User.find_by(username: complaint.username)
    # puts userFrom, userTo

    text = Text.moderator_complaint(userFrom, userTo, complaint)

    markup = M::Inline.moderator_complaint(complaint)
    Send.mes(text, markup)
  end
  userTo_justifications.each do |userTo|
    ##################  пока обработка толь ко телеграм ид
    complaints__by_telegram_id = Complaint.where(telegram_id: userTo.telegram_id).filter do |complaint|
      complaint.status == 'accepted_complaint'
    end
    complaints__by_username = Complaint.where(username: userTo.username).filter do |complaint|
      complaint.status == 'accepted_complaint'
    end
    accepted_complaints = complaints__by_username + complaints__by_telegram_id

    Send.mes(
      Text.justification_request_to_moderator(accepted_complaints, userTo),
      M::Inline.justification_request_to_moderator(userTo)
    )
  end

  Send.mes(Text.not_complaints) if complaints_to_moderator.empty? && userTo_justifications.empty?
end

def publishing_in_channel(complaint, invite_link_data)
  main_bot = Telegram::Bot::Client.new(ENV['TOKEN_MAIN'])

  scammer = if complaint.telegram_id.present?
              User.find_by(telegram_id: complaint.telegram_id)
            else
              User.find_by(username: complaint.username)

            end

  res = main_bot.api.send_message(text: Text.publication_in_channel(complaint, scammer, invite_link_data),
                                  chat_id: ENV['TELEGRAM_CHANNEL_ID'], parse_mode: 'HTML')
  complaint.update(mes_id_published_in_channel: res['result']['message_id'])
end

def get_complaint_by_button
  complaint_id = $mes.data.split('/').first
  complaint = Complaint.find_by(id: complaint_id)
end

def update_black_list_user_whith_scamer_status(complaint)
  user = if complaint.telegram_id.present?
           User.find_by(telegram_id: complaint.telegram_id)
         else
           User.find_by(username: complaint.username)
         end

  user.update!(
    status: :suspect,
    managed_status_by: :moderator,
    # status: 'scamer:managed_by_moderator',
    date_when_became_a_scamer: DateTime.now
  )
end

def reset_amount_sended_messages
  $amount_messages = 0
  sleep 60
end

def increment_decisions
  $user.access_amount = $user.access_amount + 1
  $user.decisions_per_day_amount = $user.decisions_per_day_amount + 1
  $user.save
end

def handle_accept_complaint # rubocop:disable Metrics/MethodLength,Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
  complaint = get_complaint_by_button
  return if complaint.nil?

  # if  actual_complaint?(complaint)
  # добавление в статистику решений модератора
  increment_decisions

  notify_message = Send.mes(Text.loading_requiest)

  limit_messages = 20
  $amount_messages = 0

  invite_link_data = ''

  scammer = if complaint.telegram_id.present?
              User.find_by(telegram_id: complaint.telegram_id)
            else
              User.find_by(username: complaint.username)
            end

  scammer_data = scammer.username
  scammer_data = "@#{scammer_data}" unless scammer_data.nil?
  scammer_data ||= scammer.telegram_id
  main_bot = Telegram::Bot::Client.new(ENV['TOKEN_MAIN'])

  begin
    voices = complaint.media_data['voice_file_ids']
    videos = complaint.media_data['video_note_file_ids']
    option_texts = complaint.media_data['texts']
    photos = complaint.photo_file_ids
    if voices.any? || videos.any?
      # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      # puts 'create_private_channel_by_userbot(scammer_data)'
      # puts  'scammer_data', scammer_data.inspect
      response = create_private_channel_by_userbot(scammer_data)
      invite_link_data = JSON.parse(response)
      # puts  'invite_link_data', invite_link_data.inspect

      sleep 1 # так как бывает что бот ещё не успел стать участником канала
      if invite_link_data['result'] === 'error'
        Send.mes(invite_link_data, to: ENV['CHAT_ID_MY'])
      elsif invite_link_data['result'] === 'success'

        channel_telegram_id = invite_link_data['telegram_id']
        complaint.update(
          userbot_session: invite_link_data['session'],
          private_channel_telegram_id: channel_telegram_id
        )
        # основной текст жалобы
        answer = complaint.complaint_text
        answer << "\n"
        # дополнительные тексты
        option_texts.each { |text| answer << "\n#{text}" } if option_texts.any?
        main_bot.api.send_message(chat_id: channel_telegram_id, text: answer)
        $amount_messages += 1
        # скрины
        if photos.any?
          photos.each do |photo_file_id|
            main_bot.api.sendPhoto(chat_id: channel_telegram_id, photo: photo_file_id)
            $amount_messages += 1
            reset_amount_sended_messages unless $amount_messages < limit_messages
          end
        end
        # кружки - видео
        # sleep 2 #
        if videos.any?
          videos.each do |video_file_id|
            main_bot.api.sendVideoNote(chat_id: channel_telegram_id, video_note: video_file_id)
            $amount_messages += 1
            reset_amount_sended_messages unless $amount_messages < limit_messages
          end
        end
        # голосовые сообщения
        if voices.any?
          voices.each do |voice_file_id|
            main_bot.api.sendVoice(chat_id: channel_telegram_id, voice: voice_file_id)
            $amount_messages += 1
            reset_amount_sended_messages unless $amount_messages < limit_messages
          end
        end
        # какой-то одинаковый текст

        main_bot.api.send_message(chat_id: channel_telegram_id, text: Text.private_channel_post_text,
                                  parse_mode: 'HTML')
        $amount_messages += 1
        reset_amount_sended_messages unless $amount_messages < limit_messages
        # если добавляли видео боту через команду /config channel-videl, то видео
        config = Config.first
        if config
          last_video = config.for_private_channel_video_file_ids.last
          if last_video
            main_bot.api.sendVideo(chat_id: channel_telegram_id, video: last_video,
                                   caption: Text.private_channel_post_video_caption, parse_mode: 'HTML')
          end
        end
      end
    end
  rescue StandardError => e
    is_proxies_expired = e.message.include?("unexpected token at ''")
    is_connection_refused = e.message.include?('Connection refused')
    if is_proxies_expired | is_connection_refused
      bot_moderator = Telegram::Bot::Client.new(ENV['TOKEN_MODERATOR'])
      message = 'Аренда прокси закончена, юзерботы отключены, свяжитесь с разработчиком'
      Moderator.all.each do |moderator|
        bot_moderator.api.send_message(chat_id: moderator.telegram_id, text: message)
      rescue StandardError
      end
    end
    text =  "<b>scammer_data =</b> #{scammer_data}"
    text << "\n<b>invite_link_data =</b> #{invite_link_data}"
    text << "\n<b>from userbot on created channel scammer_id =</b>#{scammer.id} <b>complaint_id =</b>#{complaint.id} #{e}"
    Send.mes(text, to: ENV['CHAT_ID_MY'])
    # Send.mes(error.backtrace, to: ENV['CHAT_ID_MY'])
  end

  publishing_in_channel(complaint, invite_link_data)

  complaint.update(
    status: 'accepted_complaint',
    handled_moderator_id: $user.id
  )
  update_black_list_user_whith_scamer_status(complaint)
  Send.mes(Text.handle_accept_complaint(complaint))
  main_bot.api.send_message(
    text: Text.complaint_published(complaint),
    chat_id: complaint.user.telegram_id,
    parse_mode: 'HTML'
  )
  $bot.api.delete_message(chat_id: $mes.message.chat.id, message_id: notify_message['result']['message_id'])
  # else
  #     Send.mes(Text.was_handled)
  # end
end

def is_already_handled?
  complaint = get_complaint_by_button
  return if complaint.nil?

  # puts complaint.status
  complaint.status != 'request_to_moderator'
end

def handle_reject_complaint
  complaint = get_complaint_by_button
  # return if complaint.nil?

  if actual_complaint?(complaint)
    $user.reject_amount = $user.reject_amount + 1
    $user.decisions_per_day_amount = $user.decisions_per_day_amount + 1
    $user.save

    complaint.update!(
      status: 'rejected_complaint',
      handled_moderator_id: $user.id
    )
    $user.update(cur_complaint_id: complaint.id)
    Send.mes(Text.input_cause_of_reject)
  else
    Send.mes(Text.was_handled)
  end
end

def get_scamer_by_button
  scamer_id = $mes.data.split('/').first
  scamer = User.find(scamer_id)
end

def send_notify_to(user, text)
  main_bot = Telegram::Bot::Client.new(ENV['TOKEN_MAIN'])
  main_bot.api.send_message(
    chat_id: user.telegram_id,
    text:,
    parse_mode: 'HTML'
  )
end

def accessing_justification
  scamer = get_scamer_by_button

  return already_handled unless actual_scamer?(scamer)

  increment_decisions
  complaints__by_telegram_id = Complaint.where(telegram_id: scamer.telegram_id).where(status: 'accepted_complaint')
  complaints__by_username    = Complaint.where(username: scamer.username).where(status: 'accepted_complaint').where.not(telegram_id: scamer.telegram_id)
  # уникальные
  accessed_complaints = complaints__by_telegram_id + complaints__by_username
  mes = Send.mes(Text.loading_requiest)
  #####################
  post_links = []
  if accessed_complaints.any? # есть жалобы # нет жалоб. изменено администратором
    accessed_complaints.each do |complaint|
      begin
        channel_telegram_id = complaint.private_channel_telegram_id # ENV['TELEGRAM_CHANNEL_ID']
        user_telegram_id = $user.telegram_id
        session = complaint.userbot_session

        result = add_admin_status_to_channel(channel_telegram_id, user_telegram_id, session)
      rescue StandardError => e
        is_proxies_expired = e.message.include?("unexpected token at ''")
        is_connection_refused = e.message.include?('Connection refused')

        if is_proxies_expired | is_connection_refused
          bot_moderator = Telegram::Bot::Client.new(ENV['TOKEN_MODERATOR'])
          message = 'Аренда прокси закончена, юзерботы отключены, свяжитесь с разработчиком'
          Moderator.all.each do |moderator|
            bot_moderator.api.send_message(chat_id: moderator.telegram_id, text: message)
          rescue StandardError
          end
        end
      end
      complaint.update(status: 'rejected_complaint')
      has_voices = complaint.media_data['voice_file_ids'].any?
      has_videos = complaint.media_data['video_note_file_ids'].any?
      if has_voices || has_videos
        post_links << "#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}"
      end
    end
  end
  ####################
  message_id = mes['result']['message_id']
  $bot.api.delete_message(chat_id: $mes.message.chat.id, message_id:)
  scamer.update!(
    status: 'not_scamer:managed_by_moderator',
    state_aasm: 'start',
    justification: nil
  )
  clear_user = scamer
  text = Text.accessing_justification(post_links)
  Send.mes(text)
  send_notify_to(clear_user, Text.you_not_scamer(scamer))
end

def blocking_scamer
  scamer = get_scamer_by_button

  if actual_scamer?(scamer)
    $user.block_amount = $user.block_amount + 1
    $user.decisions_per_day_amount = $user.decisions_per_day_amount + 1
    $user.save

    complaint = Complaint.where(telegram_id: scamer.telegram_id).find_by(status: 'accepted_complaint')

    scamer.update!(status: 'scamer:blocked_by_moderator')
    Send.mes(Text.blocking_user)
    send_notify_to(scamer, Text.you_blocked(complaint, scamer))
  else
    already_handled
  end
end
