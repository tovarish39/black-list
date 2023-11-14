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

def update_user_by_telegram_id user, mes
  user.update(
    username:mes.from.username,
    first_name:mes.from.first_name,
    last_name:mes.from.last_name
  )
  user
end

def update_user_by_username user, mes
  user.update(
    telegram_id:mes.from.id,
    first_name:mes.from.first_name,
    last_name:mes.from.last_name
  )
  user
end



def merge_users user_by_telegram_id, user_by_username, mes
  # оставляем user_by_telegram_id, 
  # обновляем поле username из users_by_username, 
  user_by_telegram_id.username = user_by_username.username
  # обновляем поле статус. если у кого-то был статус - скамер, то пишем скамер
  status = (user_by_telegram_id.status =~ /^scamer/) ? user_by_telegram_id.status : user_by_username.status
  user_by_telegram_id.status = status
  # обновляем поля  last_name и first_name из mes
  user_by_telegram_id.first_name = mes.from.first_name
  user_by_telegram_id.last_name = mes.from.last_name
  user_by_telegram_id.save
  # переписываем все жалобы поданые на юзернейм на юзера с телеграм ид
  complaints_to_username = Complaint.where(username:user_by_username.username)
  if complaints_to_username.any?
    complaints_to_username.each do |complaint|
      complaint.update(
        telegram_id:user_by_telegram_id.telegram_id,
        first_name:user_by_telegram_id.first_name,
        last_name:user_by_telegram_id.last_name,
      )
    end
  end
  # переписываем все жалобы созданные юзернеймом на юзера с телеграм ид
  # complaints_from_username = Complaint.where()
  complaints_from_username = user_by_username.complaints
  if complaints_from_username.any?
    complaints_from_username.update(
      user_id:user_by_telegram_id.id
    )
  end
  # удаляем юзера с юзернеймом
  user_by_username.destroy
  return user_by_telegram_id
end


def get_user mes
  # варианты записей юзера в бд

  # при сообщении боту # при подаче жалобы
  # - telegram_id: string
  # - username:    nil

  # при сообщении боту # при подаче жалобы
  # - telegram_id: string
  # - username:    string

  # при подаче жалобы
  # - telegram_id: nil
  # - username:    string

  # при подаче 2-х жалоб отдельно на username и отдельно на telegram_id
  # - telegram_id: string    &     telegram_id: nil     
  # - username:    nil       &     username:    string  

 # алгоритм поиска
 # ищем по telegram_id 
 # ищем по username если mes.from.id.present?
 
 # комбинации 
 # есть telegram_id нету по username + - => 1-н user       => создавался или через жалобу или на прямую => update_user()               
 # есть telegram_id есть по username + + => 2-а юзера в бд => создавались через жалобу                  => merge_users() => update_user()                 
 # нету telegram_id есть по username - + => 1-н user       => создавался через жалобу                   => update_user()
 # нету telegram_id нету по username - - => 0              => нету юзера                                => create_user()


  user_by_telegram_id = User.find_by(telegram_id:mes.from.id)
  user_by_username    = User.find_by(username:mes.from.username) if mes.from.username.present?

  # проверка что user_by_telegram_id и user_by_username не один и тот же user
  is_two_accounts = (user_by_telegram_id && user_by_username) && (user_by_telegram_id.id != user_by_username.id)
  user = if is_two_accounts
           merge_users(user_by_telegram_id, user_by_username, mes)
         elsif user_by_telegram_id
           update_user_by_telegram_id(user_by_telegram_id, mes)
         elsif user_by_username
           update_user_by_username(user_by_username, mes)
         else
          User.create(
            telegram_id: $mes.from.id,
            username:    $mes.from.username,
            first_name:  $mes.from.first_name,
            last_name:   $mes.from.last_name  
          ) 
         end
  user
end

def handle
  return if !$mes.from # заглушка
  # бот получая любое сообщение от юзера (через группу или через прямое общение)
  # ищет в бд по телеграм ид и юзернейму (возможно 2-а аккаунта, так как жалоба может подаваться или на юзернейм без телеграм ид или на телеграм ид без юзернейма)
  # если находится один аккаунт, то обновляются данные юзера
  # если находятся 2-а аккаунта, то происходит их слияние
  # если нету аккаунтов, то создаётся новый юзер
  $user = get_user($mes)
  # ####### group
  if mes_from_group_and_text?

    # если юзер есть в бд!
    # когда кто-то пишет в группе нужно проверить скамер он или нет
    # нужно делать слияние юзеров в бд когда пишет юзер с телеграм ид и юзернеймом, которые каждый есть в бд
    # $lg ||= Ru # если в группах любых где у пользователя не определён язык
    if $user && $user.status =~ /^scamer/ # если в группе пишет скаммер
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
      $user ||= create_user(User)
      $lg = $user.lg #if $user
      # puts $user.inspect

      # ##############
      if $mes.instance_of?(ChatMemberUpdated) # реагирует только от private chat
        $user.update(chat_member_status: $mes.new_chat_member.status ) if $mes.new_chat_member.status.present?
      elsif new_private_channel_video?() 
        write_video()
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
    end
  # rescue  => exception
  #   Send.mes(exception.message, to: ENV['CHAT_ID_MY'])
    # Send.mes("<b>@user = </b>#{$user.inspect}", to: ENV['CHAT_ID_MY'])
    # Send.mes("<b>@mes = </b>#{$mes.inspect}", to: ENV['CHAT_ID_MY'])
    # Send.mes(exception.backtrace, to: ENV['CHAT_ID_MY'])

end

def new_private_channel_video?
  !mes_data?() && $mes.caption && ($mes.caption === '/config channel-video') && $mes.video && $mes.video.file_id
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