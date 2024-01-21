class StateMachine
  class_eval do
    include AASM
    aasm do
      state :input_username

      event :input_username_action, from: :input_username do
        # кнопка "Пропустить" - завершение complaint
        transitions if: -> { mes_text?(Button.skip) }, after: :details_ready, to: :start
        # кнопка "Отмена"  - отмена complaint
        transitions if: -> { mes_text?(Button.cancel) }, after: :to_start, to: :start
        # ввод username - завершение complaint
        transitions if: -> { mes_text? }, after: :getting_username, to: :start
      end
    end
  end
end

def getting_username
  complaint = Complaint.find_by(id: $user.cur_complaint_id)
  username = $mes.text.sub('@', '')
  complaint.update(username:)
  details_ready
  # Send.mes(Text.handle_username(username))
end

# def reset_username
#     complaint = Complaint.find_by(id:$user.cur_complaint_id)
#     complaint.update(username:nil)
#     details_ready
# end
