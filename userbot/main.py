import socket
import re
from time import sleep
from telethon import TelegramClient
from config import hostname, port

MAX_RECV_BYTE = 1024  # Maximum bytes for receiving

# Create a TCP socket
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.bind((hostname, port))
server_socket.listen(1)  # Listen maximum 1 connection, others goes to queue

# Create telegram userbot session
api_id = 29300348
api_hash = '5cabac45e31236f5cbad0c9e2396ab08'
client = TelegramClient('goosebumps', api_id, api_hash)


async def main():
    try:
        while True:
            # Wait for connection
            client_socket, client_address = server_socket.accept()

            # Variables
            response = 'Error'
            button_flag = False

            # Receive the string from Ruby
            received_string = client_socket.recv(MAX_RECV_BYTE).decode()
            received_string = re.findall(r"(?<=\/telegram_id\/).*|$", received_string)
            if not received_string or received_string == '':
                client_socket.send(response.encode())
                client_socket.close()
                continue

            # Send the string to the bot
            await client.send_message('opencheckbot', received_string[0])

            sleep(1)

            # Press 'Telegram' button
            async for message in client.iter_messages('opencheckbot', limit=1):
                if message.buttons is not None:
                    for button_list in message.buttons:
                        for button in button_list:
                            if button.text == 'Telegram' and not button_flag:
                                await button.click()
                                button_flag = True
                                break
                        else:
                            continue
                        break

            # If button is not pressed
            if button_flag:
                sleep(1)

                async for message in client.iter_messages('opencheckbot', limit=1):
                    response = message.text

            # Send response and close the client socket
            client_socket.send(response.encode())
            client_socket.close()
    finally:
        # Close the server socket
        server_socket.close()

# Run main function
with client:
    client.loop.run_until_complete(main())
