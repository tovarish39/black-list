def pretty_print_object(obj, indent = 0)
  obj.each do |key, value|
    if value.is_a?(Hash) || value.is_a?(Telegram::Bot::Types::Base)
      puts "#{' ' * indent}#{key}:"
      pretty_print_object(value, indent + 2)
    else
      puts "#{' ' * indent}#{key}: #{value.inspect}"
    end
  end
end
# json = JSON.parse($mes.to_json)
# puts pretty_print_object(json, 1)


$is_next_forward_message = false
$forwarder_user_telegram_id = ''
$lookuping = false
$verifing = false

def handle
  # ####### group
  if mes_from_group_and_text?
    # $lg ||= Ru # если в группах любых где у пользователя не определён язык
    if $user.status =~ /^scamer/ # если в группе пишет скаммер
    # json = JSON.parse($mes.to_json)
    # puts pretty_print_object(json, 1)
    $bot.api.send_message(
      chat_id:$mes.chat.id,
      reply_to_message_id:$mes.message_id,
      text:Text.verifying_user($user, 'scamer'),
      parse_mode:'HTML'
    )
    else # /verify или /lookup и не скаммер сам
      # для forward следующий mes проверяется
      if mes_text?(/^\/lookup$/)
        $is_next_forward_message = true
        $forwarder_user_telegram_id = $mes.chat.id
        $lookuping = true
        # проверка следующего после /lookup с forwarted
      elsif $lookuping && $is_next_forward_message && ($forwarder_user_telegram_id == $mes.chat.id) && $mes.forward_from.present?
        $is_next_forward_message = false
        $forwarder_user_telegram_id = ''
        $lookuping = false
        handle_text_to_lookup($mes.chat.id)
      
        # для forward следующий mes проверяется
      elsif mes_text?(/^\/verify$/)
        $is_next_forward_message = true
        $forwarder_user_telegram_id = $mes.from.id
        $verifing = true
        # проверка следующего после /verify с forwarted
      elsif $verifing && $is_next_forward_message && ($forwarder_user_telegram_id == $mes.from.id) && $mes.forward_from.present?
        $is_next_forward_message = false
        $forwarder_user_telegram_id = ''
        $verifing = false
        handle_forwarded_message_to_verifying()
        
      # проверка по ид или юзернейму
      elsif mes_text?(/^\/lookup /) 
          $is_next_forward_message = false
          handle_text_to_lookup($mes.chat.id)
      elsif mes_text?(/^\/verify /) 
          $is_next_forward_message = false
          handle_verify_with_id_or_username()        
      end
    end
  else
      $user = user_search_and_update_if_changed(User)
      $user ||= create_user(User)
      $lg = $user.lg if $user
      # puts $user.inspect

      # ##############
      if $mes.instance_of?(ChatMemberUpdated) # реагирует только от private chat
        $user.update(chat_member_status: $mes.new_chat_member.status ) if $mes.new_chat_member.status.present?
      elsif new_private_channel_video?()
        write_video()
      elsif !$mes.from; # заглушка   
      elsif !is_bot_administrator_of_channel? # сообщение себе
      elsif user_is_blocked_by_moderator? 
      elsif !user_is_member_of_channel? && $lg.present? # если выбран язык, но не подписан на канал
        require_subscribe_channel()
  # при любых state_aasm 
      elsif $lg.present? && mes_text?(Button.support)
        Send.mes(Text.support, M::Inline.link_to_support)
      elsif $lg.present? && mes_text?(Button.oracle_tips)
        Send.mes(Text.oracle_tips, M::Inline.link_to_oracles_tips)
  ###################### 
      elsif mes_text?('/reset_lg')
         $user.update(lg:nil)
      elsif mes_text? || mes_data? || is_user_shared? || mes_photo? || mes_voice? || mes_video_note?

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
  # puts 'stop handle ----------------------'
    end

  rescue  => e
    Send.mes(e, to: ENV['CHAT_ID_MY'])
    Send.mes("<b>@user = </b>#{$user.inspect}", to: ENV['CHAT_ID_MY'])
    Send.mes("<b>@mes = </b>#{$mes.inspect}", to: ENV['CHAT_ID_MY'])
    Send.mes(e.backtrace, to: ENV['CHAT_ID_MY'])

end

def new_private_channel_video?
  $mes.caption && ($mes.caption === '/config channel-video') && $mes.video && $mes.video.file_id
end

def write_video
  config = Config.first
  config ||= Config.create
  videos = config.for_private_channel_video_file_ids
  videos << $mes.video.file_id
  config.update(for_private_channel_video_file_ids:videos)
end

def result_of_verifying user, data
#   puts user
# puts data
  if user.present? && user.status =~ /^scamer/
    Send.mes(Text.verifying_user(user, 'scamer'))
  elsif user.present? && user.status =~ /^verified/
    Send.mes(Text.verifying_user(user,'verified'))
  elsif user.present?  && user.status =~ /^not_scamer/
    Send.mes(Text.verifying_user(user, 'not_scamer'))
  elsif user.nil?
    Send.mes(Text.verifying_user(user, 'not_scamer'))
  elsif user.present? && user.status =~ /trusted/
    Send.mes(Text.verifying_user(user, 'trusted'))
  elsif user.present? && user.status =~ /dwc/
    Send.mes(Text.verifying_user(user, 'dwc'))
  end
end

def handle_forwarded_message_to_verifying

  checking_telegram_id = $mes.forward_from.id
  user = User.find_by(telegram_id:checking_telegram_id)
  result_of_verifying(user, checking_telegram_id)
end

def handle_verify_with_id_or_username
  data = $mes.text.split(' ')[1]
  user = if data =~ /^\d+$/ # telegram_id
           User.find_by(telegram_id:data)
         else # username
           User.find_by(username:data.sub('@', ''))
         end
  result_of_verifying(user, data)
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