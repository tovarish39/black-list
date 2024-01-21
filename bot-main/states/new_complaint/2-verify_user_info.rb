# frozen_string_literal: true

class StateMachine
  class_eval do
    include AASM
    aasm do
      state :verify_user_info

      event :verify_user_info_action, from: :verify_user_info do
        transitions if: -> { mes_text?(Button.cancel) }, after: :to_start, to: :start
        transitions if: -> { mes_text?(Button.verify_potential_scamer) }, after: :to_complaint_text, to: :complaint_text
      end
    end
  end
end

def to_complaint_text
  complaint_text = Video.last.complaint_text
  if complaint_text.present?
    type = complaint_text['type']
    file_id = complaint_text['file_id']
    BotMain.send("send_#{type}", caption: Text.complaint_text, reply_markup: M::Reply.complaint_text, file_id:)
  else
    Send.mes(Text.complaint_text, M::Reply.complaint_text)
  end
end
