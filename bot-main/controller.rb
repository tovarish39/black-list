def handle
    $user = user_search_and_update_if_changed(User)
    $user ||= create_user(User)
    $lg = $user.lg



  # ####### group
    if mes_from_group?
      # if $mes.class == Message && mes_from_group?
  #     if verify_with_text?
  #       username = $mes.text.split(' ').last
  #       verifying_text(username)
  #     elsif verify_text_only? # если /verify + forwarted
  #       $user.update(verifying_by_time:Time.now)
  #     elsif next_forwarted_message?
  #       $user.update(verifying_by_time:nil)
  #       verifying_by_forwarted_mes()
  #     end
  # ##############
  
  
    elsif $mes.instance_of?(ChatMemberUpdated) # реагирует только от private chat
      $user.update(chat_member_status: $mes.new_chat_member.status ) if $mes.new_chat_member.status.present?
    elsif user_is_blocked_by_moderator? 
    elsif !is_bot_administrator_of_channel? # сообщение себе
    elsif !user_is_member_of_channel? && $lg.present? # если выбран язык, но не подписан на канал
      require_subscribe_channel()
    elsif mes_text? || mes_data? || is_user_shared? || mes_photo?
      
      if $lg.nil? # язык ещё не выбран
        $user.update(state_aasm: 'language')
      elsif user_is_scamer? 
        state = $user.state_aasm
        $user.update(state_aasm:'scamer') if !['scamer','justification'].include?(state) 
        # elsif $user.state_aasm == 'scamer' || $user.state_aasm == 'justification' # чтоб не работали ниже условия
      elsif mes_text? && Button.all_main.include?($mes.text) # кнопка главного меню или /start
        $user.update(state_aasm: 'start')
      end
  
  
      event_bot = StateMachine.new
  
      from_state = $user.state_aasm.to_sym          # предидущее состояние
      event_bot.aasm.current_state = from_state
  
      event_bot.method(action(from_state)).call     # "#{from_state}_action"
  
      new_state = event_bot.aasm.current_state
      $user.update(state_aasm: new_state)
    end
  end
  
  def user_is_blocked_by_moderator?
     $user.status === 'scamer:blocked_by_moderator'
  end
  
  def user_is_scamer?
    return false if $user.status.nil?
    status = $user.status.split(':').first
    return true if status === 'scamer'
    false
  end

  def next_forwarted_message? # в течении 1 секунды
    return false if $user.verifying_by_time.nil?
    $mes.forward_from.present? && ($user.verifying_by_time > (Time.now - 1))  
  end
  
  def verify_text_only?
    $mes.text.strip == '/verify'
  end
  
  def is_bot_administrator_of_channel?
    begin
      $bot.api.getChatMember(chat_id: ENV['TELEGRAM_CHANNEL_ID'], user_id: $mes.from.id)
    rescue
      Send.mes("бот #{ENV['TOKEN_MAIN']} не администратор канала #{ENV['TELEGRAM_CHANNEL_ID']}",to:ENV['CHAT_ID_MY'])
      return false
    end
    true
  end

  def user_is_member_of_channel?
    res = $bot.api.getChatMember(chat_id: ENV['TELEGRAM_CHANNEL_ID'], user_id: $mes.from.id)
    status = res['result']['status']
    return true if status == 'member' || status == 'creator' # !'left' !'kicked'
    false
  end
  
  def require_subscribe_channel
    Send.mes(Text.require_subscribe_channel)
  end
  
  def verify_with_text?
    $mes.text  =~ /^\/verify\s@?\w+/
  end
  
  
  def verifyed_by_administrator? user
    user.status_by_moderator == 'Проверенный'
  end
  
  def is_scamer? user
    user.is_self_scamer 
  end
  
  def verifying_text raw_username
    clear_username = raw_username.delete('@')
    user = User.find_by(username:clear_username)
  
    if    user.present? && verifyed_by_administrator?(user)
      Send.mes(Text.verifyed raw_username) 
    elsif user.present? && is_scamer?(user)
      complaints = Complaint.where(telegram_id:user.telegram_id).filter {|compl| compl.mes_id_published_in_channel.present?}
      Send.mes(Text.is_scamer raw_username, complaints.first)
    else
      Send.mes(Text.not_scamer raw_username)
    end
  end
  
  def verifying_by_forwarted_mes
    user = User.find_by(telegram_id:$mes.forward_from.id)
    if    user.present? && verifyed_by_administrator?(user)
      Send.mes(Text.verifyed user.telegram_id) 
    elsif user.present? && is_scamer?(user)
      complaints = Complaint.where(telegram_id:user.telegram_id).filter {|compl| compl.mes_id_published_in_channel.present?}
      Send.mes(Text.is_scamer user.telegram_id, complaints.first)
    else
      Send.mes(Text.not_scamer $mes.forward_from.id)
    end
  end