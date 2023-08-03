# frozen_string_literal: true

class StateMachine
  class_eval do
    include AASM
    aasm do
      state :search_user

      event :search_user_action, from: :search_user do
        transitions if: -> { mes_text?(Button.cancel) }, after: :to_start, to: :start

        transitions if: -> { is_user_shared? || mes_text? }, after: :to_verify_user_info, to: :verify_user_info
      end
    end
  end
end

def is_user_shared?
  $mes.user_shared.present? ? true : false
end

def get_userTo_telegram_id
  userTo_telegram_id = if    is_user_shared?
                         $mes.user_shared[:user_id].to_s
                       elsif mes_text?
                         $mes.text
                       end
  userTo_telegram_id   
end

def to_verify_user_info
  userTo_telegram_id = get_userTo_telegram_id()

  filling_complait = $user.complaints.find_by(
    status: 'filling_by_user',
    telegram_id: userTo_telegram_id
  )

  complaint =  if filling_complait.present?
                  filling_complait
            else
               Complaint.create(
                telegram_id: userTo_telegram_id,
                user_id: $user.id,
                status: 'filling_by_user'
              )
            end
  $user.update(cur_complaint_id: complaint.id)
  begin
    data = GetChat.info(userTo_telegram_id)['result']
    complaint.username   = data['username']
    complaint.first_name = data['first_name']
    complaint.last_name  = data['last_name']
  rescue StandardError
  end
  complaint.save

  Send.mes(Text.user_info(complaint), M::Reply.user_info)
end
