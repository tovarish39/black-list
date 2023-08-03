# frozen_string_literal: true

def user_search_and_update_if_changed class_name
  model = class_name.find_by(telegram_id: $mes.from.id)
  return false if model.nil?

  username_now       = $mes.from.username
  username_writen    = model.username

  first_name_now     = $mes.from.first_name
  first_name_written = model.first_name

  last_name_now      = $mes.from.last_name
  last_name_written  = model.last_name

  model.update(username:   username_now   || '-') if username_now   != username_writen
  model.update(first_name: first_name_now || '-') if first_name_now != first_name_written
  model.update(last_name:  last_name_now  || '-') if last_name_now  != last_name_written
  model
end

def create_user class_name
  class_name.create!(
    telegram_id: $mes.from.id,
    username:    $mes.from.username   || '-',
    first_name:  $mes.from.first_name || '-',
    last_name:   $mes.from.last_name  || '-'
  ) 
end
