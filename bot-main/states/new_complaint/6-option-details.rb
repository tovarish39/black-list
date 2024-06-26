class StateMachine
  class_eval do
    include AASM
    aasm do
      state :option_details

      event :option_details_action, from: :option_details do
        # кнопка отмена
        transitions if: -> { mes_text?(Button.cancel) }, after: :to_start, to: :start
        # кнопка "Готово", когда в complaint есть username - завершение complaint
        transitions if: lambda {
                          mes_text?(Button.ready) &&  complaint_username_present?
                        }, after: :details_ready, to: :start
        # кнопка "Готово", когда в complaint нету username
        transitions if: lambda {
                          mes_text?(Button.ready) && !complaint_username_present?
                        }, after: :to_input_username, to: :input_username
        # текст, голос, кружочек
        transitions if: lambda {
                          mes_text? || mes_voice? || mes_video_note?
                        }, after: :handle_details, to: :option_details
      end
    end
  end
end

def complaint_username_present?
  complaint = Complaint.find_by(id: $user.cur_complaint_id)
  complaint.username.present?
end

def deep_clone(hash)
  Marshal.load(Marshal.dump(hash))
end

def to_input_username
  View.input_username
end

def create_or_update_potential_user_scamer(complaint)
  # puts complaint.inspect
  potential_scamer = if complaint.telegram_id.present?
                       User.find_by(telegram_id: complaint.telegram_id)
                     else # username
                       User.find_by(username: complaint.username)
                     end
  # puts potential_scamer.inspect
  if potential_scamer.nil?
    # puts '1'
    User.create(
      telegram_id: complaint.telegram_id,
      username: complaint.username,
      first_name: complaint.first_name,
      last_name: complaint.last_name
    )

  # непонятно для чего обновлять существующего юзера
  else
    # puts '2'
    potential_scamer.username = complaint.username if complaint.username.present?
    potential_scamer.first_name = complaint.first_name if complaint.first_name.present?
    potential_scamer.last_name  = complaint.last_name  if complaint.last_name.present?
    potential_scamer.save
  end
end

def notice_request(complaint)
  res = Send.mes(Text.complaint_request_to_moderator(complaint))
  mes_id = res['result']['message_id']
  $user.update(cur_message_id: mes_id)
  # puts mes_id
  to_start
end

def already_requesting_complaint_6?(complaint)
  complaints = if complaint.telegram_id.present?
                 Complaint.where(telegram_id: complaint.telegram_id)
               else
                 Complaint.where(username: complaint.username)
               end
  # has_requesting_complain = Complaint.where(telegram_id:complaint.telegram_id).where(status:'request_to_moderator')
  has_requesting_complain = complaints.where(status: 'request_to_moderator')
  has_requesting_complain.any?
end

def already_scammer_status_6?(complaint)
  userTo = User.find_by(telegram_id: complaint.telegram_id) if complaint.telegram_id.present?
  userTo ||= User.find_by(username: complaint.username) if complaint.username.present?
  # is_username_input = mes_text? && !($mes.text =~ /^-?\d+$/)

  # userTo = if  is_username_input
  #           User.find_by(username:$mes.text.sub('@',''))
  #          else
  #           userTo_telegram_id = get_userTo_telegram_id()
  #           User.find_by(telegram_id:userTo_telegram_id)
  #  end

  return false if userTo.nil?

  userTo.status =~ /^scamer/
end

def is_actual_complaint?(complaint)
  is_scamer = already_scammer_status_6?(complaint)
  if is_scamer
    Send.mes(Text.notify_already_scammer_status)
    View.start
    return false
  end

  has_complaints = already_requesting_complaint_6?(complaint)
  if has_complaints
    Send.mes(Text.notify_already_has_requesting_complaint)
    View.start
    return false
  end
  true
end

def details_ready
  complaint = Complaint.find_by(id: $user.cur_complaint_id)

  return unless is_actual_complaint?(complaint)

  notice_request complaint
  create_or_update_potential_user_scamer(complaint)
  system("bundle exec ruby #{UPLOAD_ON_FREEIMAGE} #{complaint.id} #{$user.id}")
end

def handle_details
  complaint = Complaint.find_by(id: $user.cur_complaint_id)

  return unless is_actual_complaint?(complaint)

  media_data_clone = deep_clone(complaint.media_data)

  if mes_voice?
    media_data_clone['voice_file_ids'].push($mes.voice.file_id)
    complaint.update(media_data: media_data_clone)
  end

  if mes_video_note?
    media_data_clone['video_note_file_ids'].push($mes.video_note.file_id)
    complaint.update(media_data: media_data_clone)
  end
  if mes_text?
    media_data_clone['texts'].push($mes.text)
    complaint.update(media_data: media_data_clone)
  end

  Send.mes(Text.media_data_getted)

  #   end

  # complaint.update(option_details:$mes.text)
  # notice_request complaint
  # create_or_update_potential_user_scamer(complaint)
  # system("bundle exec ruby #{UPLOAD_ON_FREEIMAGE} #{complaint.id} #{$user.id}")
end
