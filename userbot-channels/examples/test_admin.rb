# test_admin.rb - добавления админа.

require 'socket'
require 'json'


# Create a TCP socket
hostname = 'localhost'
port = 3400

socket = TCPSocket.open(hostname, port)

# Send a string to Python
string_to_send = "/add_admin_status_to_channel/-1002118169271/user/426396591/session/48732572309"
socket.puts(string_to_send)

# Receive the response from Python
socket.close_write # Without this line, the next line hangs
response = socket.read
json = JSON.parse(response)
puts json['result']
puts json['error_message']

# Close the socket
socket.close
