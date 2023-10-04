require 'socket'

# # Create a TCP socket
# hostname = '45.15.158.253'
# port = 56887

# socket = TCPSocket.open(hostname, port)

# # Send a string to Python
# string_to_send = "Telegram_id 1234"
# # string_to_send = "Hello from Ruby!"
# socket.puts(string_to_send)

# # Receive the response from Python
# response = socket.gets.chomp
# puts "Received from Python: #{response}"

# # Close the socket
# socket.close

require 'json'


# Create a TCP socket
hostname = 'localhost'
port = 3400

socket = TCPSocket.open(hostname, port)

# Send a string to Python
string_to_send = "/user_data/@poison_izzy"
socket.puts(string_to_send)

# Receive the response from Python
socket.close_write # Without this line, the next line hangs
response = socket.read
json = JSON.parse(response)
puts json['result']
puts json['telegram_id']
puts json['invite_link']


# Close the socket
socket.close



# def getInvite_link_data scammer_data
#     # result = ''
    
#     # Create a TCP socket
#     hostname = 'localhost'
#     port = 3400
    
#     socket = TCPSocket.open(hostname, port)
    
#     # Send a string to Python
#     string_to_send = "/user_data/#{scammer_data}"
#     socket.puts(string_to_send)
    
#     # Receive the response from Python
#     socket.close_write # Without this line, the next line hangs
#     result = socket.read
    
#     # Close the socket
#     socket.close

#     result
# end

# puts getInvite_link_data '1989949011'