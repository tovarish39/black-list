# frozen_string_literal: true

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


def update_user_by_telegram_id(user, mes)
  user.update(
    username: mes.from.username,
    first_name: mes.from.first_name,
    last_name: mes.from.last_name
  )
  user
end

def update_user_by_username(user, mes)
  user.update(
    telegram_id: mes.from.id,
    first_name: mes.from.first_name,
    last_name: mes.from.last_name
  )
  user
end

def merge_users(user_by_telegram_id, user_by_username, mes)
  # оставляем user_by_telegram_id,
  # обновляем поле username из users_by_username,
  user_by_telegram_id.username = user_by_username.username
  # обновляем поле статус. если у кого-то был статус - скамер, то пишем скамер
  status = user_by_telegram_id.status =~ /^scamer/ ? user_by_telegram_id.status : user_by_username.status
  user_by_telegram_id.status = status
  # обновляем поля  last_name и first_name из mes
  user_by_telegram_id.first_name = mes.from.first_name
  user_by_telegram_id.last_name = mes.from.last_name
  user_by_telegram_id.save
  # переписываем все жалобы поданые на юзернейм на юзера с телеграм ид
  complaints_to_username = Complaint.where(username: user_by_username.username)
  if complaints_to_username.any?
    complaints_to_username.each do |complaint|
      complaint.update(
        telegram_id: user_by_telegram_id.telegram_id,
        first_name: user_by_telegram_id.first_name,
        last_name: user_by_telegram_id.last_name
      )
    end
  end
  # переписываем все жалобы созданные юзернеймом на юзера с телеграм ид
  # complaints_from_username = Complaint.where()
  complaints_from_username = user_by_username.complaints
  if complaints_from_username.any?
    complaints_from_username.update(
      user_id: user_by_telegram_id.id
    )
  end
  # удаляем юзера с юзернеймом
  user_by_username.destroy
  user_by_telegram_id
end

def get_user(mes)
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

  user_by_telegram_id = User.find_by(telegram_id: mes.from.id)
  user_by_username    = User.find_by(username: mes.from.username) if mes.from.username.present?

  # проверка что user_by_telegram_id и user_by_username не один и тот же user
  is_two_accounts = (user_by_telegram_id && user_by_username) && (user_by_telegram_id.id != user_by_username.id)
  if is_two_accounts
    merge_users(user_by_telegram_id, user_by_username, mes)
  elsif user_by_telegram_id
    update_user_by_telegram_id(user_by_telegram_id, mes)
  elsif user_by_username
    update_user_by_username(user_by_username, mes)
  else
    User.create(
      telegram_id: $mes.from.id,
      username: $mes.from.username,
      first_name: $mes.from.first_name,
      last_name: $mes.from.last_name
    )
  end
end

def handle
  return unless $mes.from # заглушка
raise 'asdfasdfasdfasdf'
  # бот получая любое сообщение от юзера (через группу или через прямое общение)
  # ищет в бд по телеграм ид и юзернейму (возможно 2-а аккаунта, так как жалоба может подаваться или на юзернейм без телеграм ид или на телеграм ид без юзернейма)
  # если находится один аккаунт, то обновляются данные юзера
  # если находятся 2-а аккаунта, то происходит их слияние
  # если нету аккаунтов, то создаётся новый юзер
  $user = get_user($mes)
  # ####### group
  if GroupHandler.message_from_group?
    GroupHandler.handle
  else
    $user ||= create_user(User)
    $lg = $user.lg # if $user
    # puts $user.inspect

    # ##############
    if $mes.instance_of?(ChatMemberUpdated) # реагирует только от private chat
      $user.update(chat_member_status: $mes.new_chat_member.status) if $mes.new_chat_member.status.present?

    elsif MediaHandler.user_try_write_media?($mes)
      MediaHandler.write_media($mes)
    # elsif new_private_channel_video?()
    #   write_video()
    elsif !is_bot_administrator_of_channel? # сообщение себе
    elsif user_is_blocked_by_moderator?
    elsif !user_is_member_of_channel? && $lg.present? # если выбран язык, но не подписан на канал
      require_subscribe_channel
    # при любых state_aasm
    elsif $lg.present? && mes_text?(Button.support)
      Send.mes(Text.support, M::Inline.link_to_support)
    elsif $lg.present? && mes_text?(Button.oracle_tips)
      ControllerHelpers.view_oracle_tips
    ######################
    elsif mes_text?('/reset_lg')
      $user.update(lg: nil)
    elsif mes_text?('/reset_db')
      User.destroy_all
    elsif mes_text? || mes_data? || is_user_shared? || mes_photo? || mes_voice? || mes_video_note?

      if $lg.nil? # язык ещё не выбран
        $user.update(state_aasm: 'language')
      elsif user_is_scamer?
        state = $user.state_aasm
        $user.update(state_aasm: 'scamer') unless %w[scamer justification].include?(state)
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
  !mes_data? && $mes.caption && ($mes.caption === '/config channel-video') && $mes.video && $mes.video.file_id
end

def write_video
  config = Config.first
  config ||= Config.create
  videos = config.for_private_channel_video_file_ids
  videos << $mes.video.file_id
  config.update(for_private_channel_video_file_ids: videos)
end

def user_is_blocked_by_moderator?
  $user.status === 'scamer:blocked_by_moderator'
end

def user_is_scamer?
  return false if $user.status.nil?
  return true if $user.status == 'scammer'
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
  rescue StandardError
    Send.mes("бот #{ENV['TOKEN_MAIN']} не администратор канала #{ENV['TELEGRAM_CHANNEL_ID']}", to: ENV['CHAT_ID_MY'])
    return false
  end
  true
end

def user_is_member_of_channel?
  res = $bot.api.getChatMember(chat_id: ENV['TELEGRAM_CHANNEL_ID'], user_id: $mes.from.id)
  status = res['result']['status']
  return true if %w[member creator].include?(status) # !'left' !'kicked'

  false
end

def require_subscribe_channel
  Send.mes(Text.require_subscribe_channel)
end

def verify_with_text?
  $mes.text =~ %r{^/verify\s@?\w+}
end

def verifyed_by_administrator?(user)
  user.status_by_moderator == 'Проверенный'
end

def is_scamer?(user)
  user.is_self_scamer
end

def verifying_text(raw_username)
  clear_username = raw_username.delete('@')
  user = User.find_by(username: clear_username)

  if    user.present? && verifyed_by_administrator?(user)
    Send.mes(Text.verifyed(raw_username))
  elsif user.present? && is_scamer?(user)
    complaints = Complaint.where(telegram_id: user.telegram_id).filter do |compl|
      compl.mes_id_published_in_channel.present?
    end
    Send.mes(Text.is_scamer(raw_username, complaints.first))
  else
    Send.mes(Text.not_scamer(raw_username))
  end
end

def verifying_by_forwarted_mes
  user = User.find_by(telegram_id: $mes.forward_from.id)
  if    user.present? && verifyed_by_administrator?(user)
    Send.mes(Text.verifyed(user.telegram_id))
  elsif user.present? && is_scamer?(user)
    complaints = Complaint.where(telegram_id: user.telegram_id).filter do |compl|
      compl.mes_id_published_in_channel.present?
    end
    Send.mes(Text.is_scamer(user.telegram_id, complaints.first))
  else
    Send.mes(Text.not_scamer($mes.forward_from.id))
  end
end
