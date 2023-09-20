import socket
import re
import random
from telethon import TelegramClient
from config import hostname, port, channel_description, bot_username, channel_image_path
from os import listdir
from telethon.tl.types import InputPeerChannel, ChatAdminRights
from telethon.tl.functions.channels import CreateChannelRequest, EditAdminRequest, EditPhotoRequest, \
    GetFullChannelRequest
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
        username = f'ID{username[1:]}'
    elif username[0] == '@':
        pass
    elif username.isdigit():
        username = f'ID{username}'
    else:
        return '{result:"error", "error_message":"username or Telegram ID format is incorrect."}'

    try:
        # Create private channel
        private_channel = await client(CreateChannelRequest(
            title=f"{username} - ripper scam /// ORACLE'S LIST",
            about=channel_description(username),
            megagroup=False,
            broadcast=True,
        ))

        # Define channel data
        new_channel_id = private_channel.__dict__["chats"][0].__dict__["id"]
        new_channel_access_hash = private_channel.__dict__["chats"][0].__dict__["access_hash"]
        channel_entity = InputPeerChannel(channel_id=new_channel_id, access_hash=new_channel_access_hash)

        # Setting channel image
        await client(EditPhotoRequest(
            channel=channel_entity,
            photo=await client.upload_file(channel_image_path)
        ))

        # Adding bot and giving admin rights to bot
        await client(EditAdminRequest(
            channel=channel_entity,
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

        # Get invite link
        private_channel_id = None
        channel_info = await client(GetFullChannelRequest(channel=channel_entity))
        invite_link = channel_info.full_chat.exported_invite.link

        # Get channel id
        async for dialog in client.iter_dialogs(offset_peer=channel_entity):
            if dialog.entity.id == new_channel_id:
                private_channel_id = str(dialog.id)
                break

        # Result
        if private_channel_id is not None:
            result = '{"result":"success", "telegram_id":"'+private_channel_id+'", "invite_link":"'+invite_link+'"}'
        else:
            result = '{"result":"error", "error_message":"Channel id error."}'

        return result
    except Exception:
        e = exc_info()
        return '{"result":"error", "error_message":"'+str(e[1])+'"}'


try:
    while True:
        # Wait for connection
        client_socket, client_address = server_socket.accept()

        # Variables
        response = '{"result":"error", "error_message":"unknown error."}'

        # Receive the string from Ruby
        received_string = client_socket.recv(MAX_RECV_BYTE).decode()
        received_string = re.findall(r"(?<=/user_data/).*|$", received_string)
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

        # Run main function
        if client is not None:
            with client:
                response = client.loop.run_until_complete(create_channel(received_string[0]))
        else:
            response = "{result:'error', error_message:'client was not initialized.'}"

        # Send response and close the client socket
        client_socket.send(response.encode())
        client_socket.close()
finally:
    # Close the server socket
    server_socket.close()
