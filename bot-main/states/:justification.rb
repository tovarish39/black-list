class StateMachine
  aasm do
    state :justification

    event :justification_action, from: :justification do
      transitions if: -> { mes_text?(Button.make_a_complaint) }, after: :to_justification, to: :justification
      transitions if: -> { mes_text?(Button.request_status) }, after: :to_justification, to: :justification
      transitions if: -> { mes_text?(Button.account_status) }, after: :to_justification, to: :justification
      transitions if: -> { mes_text?('/start') }, after: :to_justification, to: :justification
      transitions if: -> { mes_text? }, after: :text_justification, to: :scamer
    end
  end
end

def justification_request_to_moderator
  accepted_complaints = Complaint.where(telegram_id: $user.telegram_id).filter do |complaint|
    complaint.status == 'accepted_complaint'
  end

  moderator_bot = Telegram::Bot::Client.new(ENV['TOKEN_MODERATOR'])
  moderators = Moderator.all
  moderators.each do |moderator|
    scamer = $user
    moderator_bot.api.send_message(
      chat_id: moderator.telegram_id,
      text: Text.justification_request_to_moderator(accepted_complaints, scamer),
      reply_markup: M::Inline.justification_request_to_moderator($user),
      parse_mode: 'HTML'
    )
  rescue StandardError
  end
end

def text_justification
  justification = $mes.text
  $user.update!(justification:)

  Send.mes(Text.justification_already_used)
  justification_request_to_moderator
end
