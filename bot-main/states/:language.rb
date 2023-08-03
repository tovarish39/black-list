# frozen_string_literal: true

class StateMachine
  aasm do
    state :language
    event :language_action, from: :language do
      transitions if: -> { mes_text? }      , after: :view_languages   , to: :language
      transitions if: -> { mes_data?(/lg/) }, after: :selected_language, to: :start
    end
  end
end

def view_languages
  Send.mes(Text.lang, M::Inline.lang)
end

def selected_language
  $lg = $mes.data.split('/').first
  $user.update(lg: $lg)
  to_start
end

def to_start
  Send.mes(Text.greet, M::Reply.start)
end