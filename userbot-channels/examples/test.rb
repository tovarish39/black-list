# Я вроде всё сделал...

# Добавил:
# • Возможность добавлять админа запросом -  /add_admin_status_to_channel/#{channel_telegram_id}/user/#{user_telegram_id}/session/#{session}
# • Возможность попытки получения Telegram ID имея username запросом - /try_get_telegram_id_by_username/#{username}


# Так же, прикладываю примеры скриптов Ruby для отправки запросов:
# test.rb - создание канала.
# test_admin.rb - добавления админа.
# test_tgid.rb - попытка получения Telegram ID.

require 'socket'
require 'json'


# Create a TCP socket
hostname = 'localhost'
port = 3400

socket = TCPSocket.open(hostname, port)

# Send a string to Python
string_to_send = "/user_data/@proverka123"
socket.puts(string_to_send)

# Receive the response from Python
socket.close_write # Without this line, the next line hangs
response = socket.read

begin
  json_success = JSON.parse(response)
  puts json_success
  # puts json['result']
  # puts json['telegram_id']
  # puts json['invite_link']
  # puts json['session']
  # puts json['error_message']
rescue 
  json_error = {result:"failed", message:"Аренда прокси закончена, юзерботы отключены, свяжитесь с разработчиком"}
  puts json_error
end






# Close the socket
socket.close
