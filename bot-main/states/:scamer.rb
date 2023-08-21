class StateMachine
  aasm do
    state :scamer
    event :scamer_action, from: :scamer do
      transitions if: -> { already_used_justification? }                                        ,after: :justification_already_used ,  to: :scamer
      transitions if: -> { mes_data?("Оспорить_justification") && !already_used_justification? },after: :to_justification         ,  to: :justification
      transitions if: -> { mes_text?() && !already_used_justification? }                        , after: :view_complaints_to_scamer, to: :scamer
    end
  end
end

def already_used_justification?
  $user.justification.present?
end

def view_complaints_to_scamer
  # accepted_complaints = Complaint.where(telegram_id:$user.telegram_id).filter {|complaint| complaint.status == 'accepted_complaint'}
  # telegraph_links = accepted_complaints.map(&:telegraph_link) 
  # Send.mes(Text.view_complaints(telegraph_links), M::Inline.view_complaints)
  Send.mes(Text.become_scamer, M::Inline.view_complaints)
end

def to_justification
  Send.mes(Text.explain_justification)
end

def justification_already_used
  accepted_complaints = Complaint.where(telegram_id:$user.telegram_id).filter {|complaint| complaint.status == 'accepted_complaint'}
  telegraph_links = accepted_complaints.map(&:telegraph_link)
  Send.mes(Text.view_complaints(telegraph_links))
  # Send.mes(Text.justification_already_used)
end