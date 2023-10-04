# require 'telegram/bot'

# token = '6568325587:AAHjqGl4nXwtQzUOWmRYDPXbC7JVT3uO0AU'

# Telegram::Bot::Client.run(token) do |bot|
#   bot.listen do |message|

#     text = "📧  **ID:** `1469546090`\n🗝 **Account Creation Date:** ≈01/2021 (3 years)\n🗃 **Profile changes:** \n└   11.08.2023 - @Oleg\\_star314 | Oleg | "
#     # text = "📧  **ID:** `1469546090`\n🗝 **Account Creation Date:** ≈01/2021 (3 years)\n🗃 **Profile changes:** \n└   11.08.2023 - @Oleg_star314 | Oleg | "


#     bot.api.send_message(chat_id: message.chat.id, text: text, parse_mode:'Markdown')
#   end
# end




text = "📧  **ID:** `146_9546090`\n🗝 **Account Creation Date:** ≈01/2021 (3 years)\n🗃 **Profile changes:** \n└   11.08.2023 - @Oleg_star314 | Oleg | "


puts text.gsub(/_/, '\\\\\\_')


# require 'socket'
# require 'json'


# # Create a TCP socket
# hostname = 'localhost'
# port = 3400

# socket = TCPSocket.open(hostname, port)

# # Send a string to Python
# string_to_send = "/user_data/@kek"
# socket.puts(string_to_send)

# # Receive the response from Python
# socket.close_write # Without this line, the next line hangs
# response = socket.read
# json = JSON.parse(response)
# puts json['result']
# puts json['telegram_id']
# puts json['invite_link']


# # Close the socket
# socket.close
