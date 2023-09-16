import socket
import re
import random
from telethon import TelegramClient
from config import hostname, port, channel_description, bot_username, channel_image_path
from os import listdir
from telethon.tl.types import InputPeerChannel, ChatAdminRights
from telethon.tl.functions.channels import CreateChannelRequest, CheckUsernameRequest, UpdateUsernameRequest, EditAdminRequest, EditPhotoRequest
from sys import exc_info

MAX_RECV_BYTE = 1024  # Maximum bytes for receiving

# Create a TCP socket
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.bind((hostname, port))
server_socket.listen(1)  # Listen maximum 1 connection, others goes to queue

# Define API ID, API hash,
api_id = 29300348
api_hash = '5cabac45e31236f5cbad0c9e2396ab08'
client = None


async def create_channel(username: str) -> str:
    # Format username
    if username[0] == '-' and username[1:].isdigit():
        username = f'id{username[1:]}'
    elif username[0] == '@':
        pass
    elif username.isdigit():
        username = f'id{username}'
    else:
        return 'Error: username or Telegram ID format is incorrect.'

    try:
        # Create private channel
        private_channel = await client(CreateChannelRequest(
            title=f'Жалобы на {username}',
            about=channel_description,
            megagroup=False,
            broadcast=True,
        ))

        # Define variables for making channel public
        new_channel_id = private_channel.__dict__["chats"][0].__dict__["id"]
        new_channel_access_hash = private_channel.__dict__["chats"][0].__dict__["access_hash"]
        public_channel_username = f'{username}_reports' if username[0] != '@' else f'{username[1:]}_reports'

        # Setting channel image
        await client(EditPhotoRequest(
            channel=InputPeerChannel(channel_id=new_channel_id, access_hash=new_channel_access_hash),
            photo=await client.upload_file(channel_image_path)
        ))

        # Check channel name
        check_username = await client(CheckUsernameRequest(
            channel=InputPeerChannel(channel_id=new_channel_id, access_hash=new_channel_access_hash),
            username=public_channel_username,
        ))

        # Making channel public
        while not check_username:
            public_channel_username += str(random.randrange(10))
            check_username = await client(CheckUsernameRequest(
                channel=InputPeerChannel(channel_id=new_channel_id, access_hash=new_channel_access_hash),
                username=public_channel_username,
            ))
        else:
            await client(UpdateUsernameRequest(
                channel=InputPeerChannel(channel_id=new_channel_id, access_hash=new_channel_access_hash),
                username=public_channel_username,
            ))

        # Giving admin rights to the bot
        await client(EditAdminRequest(
            channel=public_channel_username,
            user_id=bot_username,
            admin_rights=ChatAdminRights(
                change_info=True,
                post_messages=True,
                edit_messages=True,
                delete_messages=True,
                ban_users=True,
                invite_users=True,
                pin_messages=True,
                add_admins=True,
                anonymous=True,
                manage_call=True,
                other=True,
                manage_topics=True
            ),
            rank='administrator'
        ))

        return public_channel_username
    except Exception:
        e = exc_info()
        return f'Error: {e[1]}'


try:
    while True:
        # Wait for connection
        client_socket, client_address = server_socket.accept()

        # Variables
        response = 'Error'

        # Receive the string from Ruby
        received_string = client_socket.recv(MAX_RECV_BYTE).decode()
        received_string = re.findall(r"(?<=\/user_data\/).*|$", received_string)
        if not received_string or received_string == '':
            client_socket.send(response.encode())
            client_socket.close()
            continue

        # Get sessions from sessions directory
        dirlist = listdir('./sessions')
        sessions = [file for file in dirlist if re.match(r".*\.session$", file) is not None]

        # Client initialization
        if sessions is not []:
            session_name = re.findall(r'.*(?=\.session)|$', random.choice(sessions))[0]
            client = TelegramClient(f'sessions/{session_name}', api_id, api_hash)
        else:
            response = 'Error: no sessions'

        # Run main function
        if client is not None:
            with client:
                response = client.loop.run_until_complete(create_channel(received_string[0]))
        else:
            response = 'Error: client was not initialized'

        # Send response and close the client socket
        client_socket.send(response.encode())
        client_socket.close()
finally:
    # Close the server socket
    server_socket.close()



