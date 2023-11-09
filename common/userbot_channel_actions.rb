# test_tgid.rb - попытка получения Telegram ID.

require 'socket'
require 'json'

def try_get_telegram_id_by_username username
  # Create a TCP socket
  hostname = 'localhost'
  port = 3400

  socket = TCPSocket.open(hostname, port)

  # Send a string to Python
  # string_to_send = "/try_get_telegram_id_by_username/@r33mA1337"
  string_to_send = "/try_get_telegram_id_by_username/@#{username}"
  socket.puts(string_to_send)

  # Receive the response from Python
  socket.close_write # Without this line, the next line hangs
  response = socket.read
  # json = JSON.parse(response)
  # puts json['result']
  # puts json['telegram_id']
  # puts json['error_message']


  # Close the socket
  socket.close
end

def create_private_channel_by_userbot scammer_data
  # result = ''
  
  # Create a TCP socket
  hostname = 'localhost'
  port = 3400
  
  socket = TCPSocket.open(hostname, port)
  
  # Send a string to Python
  string_to_send = "/user_data/#{scammer_data}"
  socket.puts(string_to_send)
  
  # Receive the response from Python
  socket.close_write # Without this line, the next line hangs
  result = socket.read
  
  # Close the socket
  socket.close

  result
end

def add_admin_status_to_channel channel_telegram_id, user_telegram_id, session
  # Create a TCP socket
  hostname = 'localhost'
  port = 3400

  socket = TCPSocket.open(hostname, port)

  # Send a string to Python
  string_to_send = "/add_admin_status_to_channel/#{channel_telegram_id}/user/#{user_telegram_id}/session/#{session}"
  socket.puts(string_to_send)

  # Receive the response from Python
  socket.close_write # Without this line, the next line hangs
  response = socket.read
  json = JSON.parse(response)
  puts json['result']
  puts json['error_message']

  # Close the socket
  socket.close
end