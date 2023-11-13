import socket
import re
from datetime import datetime
from telethon import TelegramClient
from config import hostname, port, channel_description, bot_username, channel_image_path
from os import listdir
from telethon.tl.types import InputPeerChannel, ChatAdminRights
from telethon.tl.functions.channels import CreateChannelRequest, EditAdminRequest, EditPhotoRequest, \
    GetFullChannelRequest, InviteToChannelRequest
from sys import exc_info

MAX_RECV_BYTE = 1024  # Maximum bytes for receiving

# Create a TCP socket
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.bind((hostname, port))
server_socket.listen(1)  # Listen maximum 1 connection, others goes to queue

# Define API ID, API hash, client
api_id = 29300348
api_hash = '5cabac45e31236f5cbad0c9e2396ab08'
client = None

# Get sessions from sessions directory
dirlist = listdir('./sessions')
sessions = [file for file in dirlist if re.match(r".*\.session$", file) is not None]

# Initialization sessions and their proxies as dictionary
sessions_proxy = {}

def get_unused_proxy() -> tuple:
    """
    Parse proxies.txt and get unused proxy.
    :return: Proxy in tuple format.
    """
    p_strings = open('./proxies.txt', 'r')
    for p_string in p_strings:
        p_split = p_string.split(':')
        proxy = ('http', p_split[0], int(p_split[1]), False, p_split[2], p_split[3].rstrip())
        if proxy not in sessions_proxy.values():
            return proxy


async def get_tg_id(username: str) -> str:
    """
    Userbot that gets Telegram ID by username.
    :param username: Username.
    :return: Success or error in json format.
    """
    try:
        # Get user info
        user_info = await client.get_entity(username)

        # Get user id
        user_id = user_info.id

        return '{"result":"success", "telegram_id":"'+str(user_id)+'"}'
    except Exception:
        e = exc_info()
        return '{"result":"error", "error_message":"'+str(e[1])+'"}'


async def add_admin(user_id: str, channel_id: str) -> str:
    """
    Userbot that adds user and gives him admin rights.
    :param user_id: Telegram user ID.
    :param channel_id: Telegram channel ID.
    :return: Success or error in json format.
    """

    # Format username
    if user_id[0] == '-' and user_id[1:].isdigit():
        user_id = int(user_id)
    elif user_id[0] == '@':
        pass
    elif user_id.isdigit():
        user_id = int(user_id)
    else:
        return '{result:"error", "error_message":"username or Telegram ID format is incorrect."}'

    try:

        # Adding user to channel
        await client(InviteToChannelRequest(
            channel=int(channel_id),
            users=[user_id]
        ))

        # Giving admin rights to user
        await client(EditAdminRequest(
            channel=int(channel_id),
            user_id=user_id,
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

        return '{"result":"success"}'
    except Exception:
        e = exc_info()
        return '{"result":"error", "error_message":"'+str(e[1])+'"}'


async def create_channel(user_data: str, userbot: str) -> str:
    """
    Userbot that creates channel and gives admin rights to the bot.
    :param user_data: Scammer username or telegram ID.
    :param userbot: Session name.
    :return: Channel info or error in json format.
    """

    # Format username
    if user_data[0] == '-' and user_data[1:].isdigit():
        user_data = f'ID{user_data[1:]}'
    elif user_data[0] == '@':
        pass
    elif user_data.isdigit():
        user_data = f'ID{user_data}'
    else:
        return '{result:"error", "error_message":"username or Telegram ID format is incorrect."}'

    try:
        # Create private channel
        private_channel = await client(CreateChannelRequest(
            title=f"{user_data} - ripper scam /// ORACLE'S LIST",
            about=channel_description(user_data),
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
            result = '{"result":"success", "telegram_id":"'+private_channel_id+'", "invite_link":"'+invite_link+'", "session":"'+userbot+'"}'
        else:
            result = '{"result":"error", "error_message":"Channel id error."}'

        return result
    except Exception:
        e = exc_info()
        return '{"result":"error", "error_message":"'+str(e[1])+'"}'

# Attach a proxy to each session
for session in sessions:
    sessions_proxy[session] = get_unused_proxy()

try:
    while True:
        # Wait for connection
        client_socket, client_address = server_socket.accept()

        # Variables
        response = '{"result":"error", "error_message":"unknown error."}'
        response_type = ''
        session_name = ''

        # Receive the string from Ruby
        received_string = client_socket.recv(MAX_RECV_BYTE).decode()

        # Logging date and received string
        print(f'\nDate: {datetime.now()}')
        print(f'Received string: {received_string.strip()}')

        if re.match(r"/add_admin_status_to_channel/.*/user/.*", received_string) is not None:
            response_type = 'add_admin_status_to_channel'
            received_string = received_string.split('/')
        elif re.match(r"/try_get_telegram_id_by_username/.*", received_string) is not None:
            response_type = 'try_get_telegram_id_by_username'
            received_string = received_string.split('/')
        else:
            response_type = 'create_channel'
            received_string = re.findall(r"(?<=/user_data/).*|$", received_string)
            if not received_string or received_string == '':
                client_socket.send(response.encode())
                client_socket.close()
                continue

        # Check for new sessions, if there is a new session then add it to 'sessions' list
        for file in listdir('./sessions'):
            if re.match(r".*\.session$", file) is not None and file not in sessions:
                sessions.append(file)
                sessions_proxy[file] = get_unused_proxy()

        # Client initialization
        if sessions is not []:
            if response_type == 'add_admin_status_to_channel':
                session_name = received_string[6].strip()
            else:
                session_name = re.findall(r'.*(?=\.session)|$', sessions[0])[0]
            client = TelegramClient(f'sessions/{session_name}', api_id, api_hash, proxy=sessions_proxy[sessions[0]])
            sessions = sessions[1:] + [sessions[0]]

        # Logging session name
        print(f'Using session: {session_name}')

        # Run main function
        if client is not None:
            with client:
                if response_type == 'add_admin_status_to_channel':
                    response = client.loop.run_until_complete(add_admin(received_string[4], received_string[2]))
                elif response_type == 'try_get_telegram_id_by_username':
                    response = client.loop.run_until_complete(get_tg_id(received_string[2].strip()))
                elif response_type == 'create_channel':
                    response = client.loop.run_until_complete(create_channel(received_string[0], session_name))
                else:
                    response = "{result:'error', error_message:'Invalid response.'}"
        else:
            response = "{result:'error', error_message:'client was not initialized.'}"

        # Send response and close the client socket
        client_socket.send(response.encode())
        client_socket.close()

        # Logging response
        print(f'Response: {response.strip()}')
finally:
    # Close the server socket
    server_socket.close()
