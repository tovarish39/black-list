# frozen_string_literal: true

class StateMachine
  class_eval do
    include AASM
    aasm do
      state :search_user

      event :search_user_action, from: :search_user do
        transitions if: -> { mes_text?(Button.cancel) }, after: :to_start, to: :start
        transitions if: lambda {
                          (is_user_shared? || mes_text?) && already_scammer_status?
                        }, after: :notify_already_scammer_status, to: :search_user
        transitions if: lambda {
                          (is_user_shared? || mes_text?) && already_requesting_complaint?
                        }, after: :notify_already_has_requesting_complaint, to: :search_user
        transitions if: -> { is_user_shared? || mes_text? }, after: :to_verify_user_info, to: :verify_user_info
      end
    end
  end
end

def get_userTo_by_mes(mes)
  data = parse_data_userTo(mes)
  if data[:type] == 'telegram_id'
    User.find_by(telegram_id: data[:value])
  elsif data[:type] == 'username'
    # проверка есть ли по найденному телеграм ид от юзербота юзер
    telegram_id = get_telegram_id_local(data)
    user = User.find_by(telegram_id:) if telegram_id
    user ||= User.find_by(username: data[:value])
  end
end

def parse_data_userTo(mes)
  type = ''
  value = ''
  if is_telegram_id_text?(mes)
    value = mes.text
    type = 'telegram_id'
  elsif is_username_text?(mes)
    value = mes.text.sub('@', '')
    type = 'username'
  elsif  is_user_shared?
    value = mes.user_shared[:user_id].to_s
    type = 'telegram_id'
  end
  { value:, type: }
end

# если есть юзер с полученным username или telegram_id и статусом скамер
def already_scammer_status?
  userTo = get_userTo_by_mes($mes)
  return false if userTo.nil?
  return false unless userTo.status =~ /^scamer/

  true
end

# def get_userTo_telegram_id
#   userTo_telegram_id =  if    is_user_shared?
#                           $mes.user_shared[:user_id].to_s
#                         elsif mes_text? && is_telegram_id($mes.text)
#                           # при вводе текста меняем "/" чтоб папки не ломало
#                           replace_invalid_characters($mes.text)
#                         else
#                            nil
#                         end
#   userTo_telegram_id
# end

# если юзер есть и на него уже составлена жалоба модератору
def already_requesting_complaint?
  userTo = get_userTo_by_mes($mes)
  if userTo
    complaints_by_telegram_id = []
    complaints_by_telegram_id = Complaint.where(telegram_id: userTo.telegram_id) if userTo.telegram_id.present?
    complaints_by_username = []
    complaints_by_username = Complaint.where(username: userTo.username) if userTo.username.present?
    complaints = complaints_by_telegram_id + complaints_by_username
    complaints.each do |complaint|
      return true if complaint.status == 'request_to_moderator'
    end
  end
  false
end

def notify_already_scammer_status
  Send.mes(Text.notify_already_scammer_status, M::Reply.search_user)
end

def notify_already_has_requesting_complaint
  Send.mes(Text.notify_already_has_requesting_complaint, M::Reply.search_user)
end

def is_user_shared?
  $mes.user_shared.present? ? true : false
end

def replace_invalid_characters(input_string)
  invalid_characters = ['/', '\\', '?', '*', ':', '"', '<', '>', '|', "\0", "\t", "\n", "\r"]
  input_string.gsub(/[#{Regexp.escape(invalid_characters.join)}]/, '_')
end

def is_telegram_id(text)
  /^-?\d+$/ =~ text
end

def get_telegram_id_local(data)
  # попытка достать telegram_id по username от userbot
  # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  # получение телеграм ид от юзербота
  # если прокси закончился, то сообщение всем модераторам
  begin
    res = try_get_telegram_id_by_username(data[:value])
    # данные пока не вставляются
    # не известен положительный ответ от юзербота
    telegram_id = res['telegram_id'] if res['result'] == 'success'
  rescue StandardError => e
    not_found = e.message.include?('Cannot find any entity corresponding to')
    is_proxies_expired = e.message.include?("unexpected token at ''")
    is_connection_refused = e.message.include?('Connection refused')
    if is_proxies_expired | is_connection_refused
      bot_moderator = Telegram::Bot::Client.new(ENV['TOKEN_MODERATOR'])
      message = 'Аренда прокси закончена, юзерботы отключены, свяжитесь с разработчиком'
      Moderator.all.each do |moderator|
        bot_moderator.api.send_message(chat_id: moderator.telegram_id, text: message)
      rescue StandardError
      end
    end
    telegram_id = nil
  end
  telegram_id
end

# если на введённые данные telegram_id или username
# уже есть начатая жалоба, то заполняем её
# иначе создаём новую на введённые данные
# если введён username пытаемся достать telegram_id через бота
def to_verify_user_info
  # если введён юзернейм, по этому юзернейму не найдена complaint.status == 'filling_by_user'
  # но уже есть поданная жалоба на этот телеграм ид, то нужно не создавать новую жалобу

  # получение данных юзернейм или телеграм ид
  # поиск юзера по данным для получения остальных данных
  # если нету телеграм ид , поиск телеграм ид через юзербота
  # если есть телеграм ид от юзербота, проверка на налич

  # usetTo = get_userTo_by_mes($mes)
  data = parse_data_userTo($mes) # {type:'username'|'telegram_id', value:value}

  filling_complait = if data[:type] == 'telegram_id'
                       $user.complaints.find_by(
                         status: 'filling_by_user',
                         telegram_id: data[:value]
                       )
                     elsif data[:type] == 'username'
                       $user.complaints.find_by(
                         status: 'filling_by_user',
                         username: data[:value]
                       )
                     end

  if filling_complait.present?
    telegram_id = get_telegram_id_local(data) unless filling_complait.telegram_id.present?
    if telegram_id
      filling_complait.telegram_id = telegram_id
      filling_complait.save
    end
    complaint = filling_complait
  elsif data[:type] == 'telegram_id'
    userTo = User.find_by(telegram_id: data[:value])
    complaint = if userTo.present?
                  $user.complaints.create(
                    telegram_id: userTo.telegram_id,
                    username: userTo.username,
                    status: 'filling_by_user',
                    first_name: userTo.first_name,
                    last_name: userTo.last_name
                  )
                else
                  Complaint.create(
                    telegram_id: data[:value],
                    status: 'filling_by_user',
                    user_id: $user.id
                  )
                end
  elsif data[:type] == 'username'
    telegram_id = get_telegram_id_local(data)
    # если после получения телеграм ид стал находиться скамер или жалобы == request_to_moderator
    # то пишем что уже скамер или отправлена жалоба
    # нужно ли делать изменение userTo - не нужно!
    # if telegram_id
    #   userTo = User.find_by(telegram_id:telegram_id)
    #   if userTo && userTo =~ /^scamer/

    #   end
    # end

    complaint = Complaint.create(
      telegram_id:,
      username: data[:value],
      user_id: $user.id,
      status: 'filling_by_user'
    )
  end

  $user.update(cur_complaint_id: complaint.id)
  Send.mes(Text.user_info(complaint), M::Reply.user_info)
end
