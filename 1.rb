require 'socket'

# Create a TCP socket
hostname = 'localhost'
port = 3500

socket = TCPSocket.open(hostname, port)

# Send a string to Python
string_to_send = "/telegram_id/${12341234}"
socket.puts(string_to_send)

# Receive the response from Python
socket.close_write # Without this line, the next line hangs
response = socket.read
puts response

# Close the socket
socket.close