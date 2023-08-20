# frozen_string_literal: true

class StateMachine
  aasm do
    state :start
    event :start_action, from: :start do
      transitions if: -> { mes_text?(Button.make_a_complaint) }  , after: :to_search_user, to: :search_user
      transitions if: -> { mes_text?(Button.request_status) }    , after: :view_requests , to: :start
      transitions if: -> { mes_text?(Button.account_status) }    , after: :notify_account, to: :start
      transitions if: -> { mes_text?(Button.verify_by_userbot) } , after: :to_userbot    , to: :request_to_userbot
      transitions if: -> { mes_text?('/start') }                 , after: :to_start      , to: :start
    end   
  end
end

def clear_account
  true
end

def to_userbot
  Send.mes(Text.to_userbot)
end

def notify_account
  Send.mes(Text.clear_account)
end

def to_search_user
  Send.mes(Text.search_user, M::Reply.search_user)
end

def get_footer complaint
  case complaint.status
  when 'request_to_moderator'
    "<b>Статус:</b> ⌛На рассмотрении⌛"
  when 'accepted_complaint' 
    "<b>Статус:</b> Одобрена\n опубликована на канале"
  when 'rejected_complaint' 
    "<b>Статус:</b> ❌Отклонено❌\n #{"<b>Причина:</b> #{complaint.explanation_by_moderator}" if complaint.explanation_by_moderator.present?}"
  end
end

def view_requests
  complaints = $user.complaints.filter {|complaint| ['request_to_moderator', 'accepted_complaint', 'rejected_complaint'].include?(complaint.status)}  
 
  if complaints.any?
    complaints.each do |complaint|
      to_user = User.find_by(telegram_id:complaint.telegram_id)

      Send.mes(Text.notify_request_complaints(complaint, to_user))
      # Send.mes(Text.notify_reject_complaint(complaint, to_user)) if complaint.status == 'rejected_complaint'
      # Send.mes(Text.notify_access_complaint(complaint, to_user)) if complaint.status == 'accepted_complaint'
      # Send.mes(Text.notify_pending_complaint(complaint, to_user)) if complaint.status == 'request_to_moderator'

      # text = """#{Text.complaint(complaint)}\n#{Text.user_info(to_user)}\n<strong>Ссылка:</strong>  <a href='#{complaint.telegraph_link}'>telegraph_link</a>\n"""
      # text << get_footer(complaint)
      # $bot.api.send_message(text:text, chat_id:$mes.chat.id, parse_mode:"HTML")

    end
  else
    Send.mes(Text.not_complaints)
  end

end
