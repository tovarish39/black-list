require 'socket'

# Create a TCP socket
hostname = '45.15.158.253'
port = 56887

socket = TCPSocket.open(hostname, port)

# Send a string to Python
string_to_send = "Telegram_id 1234"
# string_to_send = "Hello from Ruby!"
socket.puts(string_to_send)

# Receive the response from Python
response = socket.gets.chomp
puts "Received from Python: #{response}"

# Close the socket
socket.close