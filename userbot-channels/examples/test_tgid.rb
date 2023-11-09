# test_tgid.rb - попытка получения Telegram ID.

require 'socket'
require 'json'


# Create a TCP socket
hostname = 'localhost'
port = 3400

socket = TCPSocket.open(hostname, port)

# Send a string to Python
string_to_send = "/try_get_telegram_id_by_username/@r33mA1337"
socket.puts(string_to_send)

# Receive the response from Python
socket.close_write # Without this line, the next line hangs
response = socket.read
json = JSON.parse(response)
puts json['result']
puts json['telegram_id']
puts json['error_message']


# Close the socket
socket.close
