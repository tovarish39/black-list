# frozen_string_literal: true

def handle
  $user = user_search_and_update_if_changed(Moderator)
  # $user ||= create_user(Moderator)
  # puts $user.inspect
  if $mes.instance_of?(ChatMemberUpdated)
    $user.update(chat_member_status: $mes.new_chat_member.status ) if $mes.new_chat_member.status.present?
  elsif (!$user)
    Send.mes(Text.require_registration)  
  elsif ($user.status == 'inactive')
    Send.mes(Text.require_active_account)
  elsif mes_text? || mes_data?

  $user.state_aasm = 'moderator' if $user.state_aasm.nil? 
    event_bot = StateMachine.new
    from_state = $user.state_aasm.to_sym          # предидущее состояние
    event_bot.aasm.current_state = from_state

    event_bot.method(action(from_state)).call     # "#{from_state}_action"

    new_state = event_bot.aasm.current_state      # новое состояние
    $user.update(state_aasm: new_state)
  end
end
