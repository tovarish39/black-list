
  def handle
    $user = user_search_and_update_if_changed(Moderator)
    # $user ||= create_user(Moderator)
    
    # if $mes.instance_of?(ChatMemberUpdated)
      # update_is_member
    if (!$user)
      $bot.api.send_message(chat_id:$mes.chat.id, text:'зарегистрируйтесь у администратора')
    elsif mes_text? || mes_data?
    #   if $lg.nil? # язык ещё не выбран
    #     $user.update(state_aasm: 'language')
    #   elsif $user.state_aasm == 'scamer' || $user.state_aasm == 'justification' # чтоб не работали ниже условия
    #   elsif mes_text? && Button.all_main.include?($mes.text) # кнопка главного меню или /start
    #     $user.update(state_aasm: 'start')
    #   end
  
    $user.state_aasm = 'moderator' if $user.state_aasm.nil? 

      event_bot = StateMachine.new
  # puts 
      from_state = $user.state_aasm.to_sym          # предидущее состояние
      event_bot.aasm.current_state = from_state
  
      event_bot.method(action(from_state)).call     # "#{from_state}_action"
  
      new_state = event_bot.aasm.current_state
      $user.update(state_aasm: new_state)
    end
  end
  