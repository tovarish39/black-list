class StateMachine
    class_eval do
      include AASM
      aasm do
        state :explanation
  
        event :explanation_action, from: :explanation do
            transitions if: -> {mes_text?(Button.active_complaints)}, to: :explanation
            transitions if: -> {mes_text?("/start")}                , to: :explanation
            
            transitions if: -> {mes_text?()}, after: :handle_explanation, to: :moderator
        end
      end
    end
  end
  
  def handle_explanation
    complaint = Complaint.find($user.cur_complaint_id)
    explanation_text = $mes.text
    potincial_scamer = User.find_by(telegram_id:complaint.telegram_id) 
    complaint.update!(
        explanation_by_moderator:explanation_text,
        # status:'rejected_complaint' 
    )
    Send.mes(Text.handle_explanation(complaint, potincial_scamer))
    black_list_bot = Telegram::Bot::Client.new(ENV['TOKEN_MAIN'])
    black_list_bot.api.send_message(
        text:Text.handle_explanation(complaint, potincial_scamer),
        chat_id:complaint.user.telegram_id,
        parse_mode:'HTML'
    )
end