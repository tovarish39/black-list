# frozen_string_literal: true

def user_search_and_update_if_changed class_name

  return if !$mes.from # хз что приходит, после того как опубилковали в новый канал данные о скамере

  model = class_name.find_by(telegram_id: $mes.from.id)
  return false if model.nil?

  username_now       = $mes.from.username
  username_writen    = model.username

  first_name_now     = $mes.from.first_name
  first_name_written = model.first_name

  last_name_now      = $mes.from.last_name
  last_name_written  = model.last_name

  chat_member_status_now = 'member'
  chat_member_status_written  = model.chat_member_status

  model.update(username:            username_now   || '-')  if username_now            != username_writen
  model.update(first_name:          first_name_now || '-')  if first_name_now          != first_name_written
  model.update(last_name:           last_name_now  || '-')  if last_name_now           != last_name_written
  model.update(chat_member_status:  chat_member_status_now) if chat_member_status_now  != chat_member_status_written
  model
end

def create_user class_name
  return if !$mes.from # хз что приходит, после того как опубилковали в новый канал данные о скамере

  user = class_name.create!(
    telegram_id: $mes.from.id,
    username:    $mes.from.username   || '-',
    first_name:  $mes.from.first_name || '-',
    last_name:   $mes.from.last_name  || '-'

  ) 
  user
end

def is_telegram_id_text? mes
  mes_text? && (mes.text =~ /^-?\d+$/)
end

def is_username_text? mes
  mes_text? && !(mes.text =~ /^-?\d+$/)
end