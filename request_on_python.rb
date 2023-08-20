require './config/requires.rb'
require 'socket'

data = ARGV[0]
from_user_telegram_id = ARGV[1]
group_chat_id = ARGV[2]

$user = User.find_by(telegram_id:from_user_telegram_id)
$lg = $user.lg


def is_telegram_id text
    text =~ /^\d+$/ 
end
def user_exist_and_scamer? data
    return false if $userTo.nil?

    $userTo.status =~ /^scamer/
end

bot = Telegram::Bot::Client.new(ENV['TOKEN_MAIN'])
res = bot.api.send_message(
    chat_id: group_chat_id || $user.telegram_id, 
    text:Text.checking
)
message_id = res['result']['message_id']
$userTo =  if is_telegram_id(data)
            User.find_by(telegram_id:data)
          else
            User.find_by(
                username: data[0]=='@'?
                    data.slice(1) :
                    data
                )
          end





formatted_data = is_telegram_id(data) ? 
    data : 
    data[0] === '@' ? 
        data : 
        "@#{data}"

response = nil
begin
    # Create a TCP socket
    hostname = 'localhost'
    port = 3500
    
    socket = TCPSocket.open(hostname, port)
    
    # Send a string to Python
    string_to_send = "/telegram_id/#{formatted_data}"
    socket.puts(string_to_send)
    
    # Receive the response from Python
    socket.close_write # Without this line, the next line hangs
    response = socket.read
    # puts response
    
    # Close the socket
    socket.close
rescue => exception
    puts exception
end

def delete_text_after_char str, char
    last_index = str.rindex(char)
    str.slice(0,last_index + 1)
end

def formatting_lines lines
    stop_words = ['Телефон', 'Возможные сервера']
    new_lines = []
    lines.each do |line|
        formatted_line = line.force_encoding('UTF-8').encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
        is_in_stop = false
        stop_words.each do |word| 
            is_in_stop = true if formatted_line.include?(word)
        end
        new_lines.push if !is_in_stop
    end
    puts  '------------------------------------'
    new_lines
end

def format_res res 
    text =  delete_text_after_char(res, '|')
    lines = text.split("\n")
    formatted_lines = formatting_lines(lines)
    formatted_lines.join("\n")
end

#  /lookup yuliapopova00


result_message = response.present? && response == 'Error' ?  
    Text.not_availible : 
    format_res(response)


bot.api.delete_message(chat_id: group_chat_id|| $user.telegram_id,  message_id:message_id)
bot.api.send_message(chat_id: group_chat_id || $user.telegram_id,  text:result_message, parse_mode:'Markdown')
def notify_scammer
    return 'Ваш контрагент обнаружен в списке кидков!' if $lg == Ru
    return 'Your counterparty has been found on the scam list!' if $lg == En
    return '¡Su contratante ha sido encontrado en la lista de estafadores!' if $lg == Es
    return '您的交易对手被发现在骗子名单上！' if $lg == Cn
end
def notify_complaint complaint
    return "Жалоба #N#{complaint.id} от #{complaint.created_at.strftime('%d.%m.%Y')}:\nСсылка <a href='#{complaint.telegraph_link}'>telegraph_link</a>" if $lg == Ru
    return "Report #N#{complaint.id} from #{complaint.created_at.strftime('%d.%m.%Y')}:\nLink <a href='#{complaint.telegraph_link}'>telegraph_link</a>" if $lg == En
    return "Informe #N#{complaint.id} del #{complaint.created_at.strftime('%d.%m.%Y')}:\nEnlace <a href='#{complaint.telegraph_link}'>telegraph_link</a>" if $lg == Es
    return "报告 #N#{complaint.id} 日期 #{complaint.created_at.strftime('%d.%m.%Y')}:\n链接 <a href='#{complaint.telegraph_link}'>telegraph_link</a>" if $lg == Cn
end


if user_exist_and_scamer?(data)
    bot.api.send_message(chat_id: group_chat_id || $user.telegram_id, text:notify_scammer)
    accepted_complaints = Complaint.where(telegram_id:$userTo.telegram_id).where(status:'accepted_complaint')
    if accepted_complaints.any?
        accepted_complaints.each do |complaint|
            bot.api.send_message(chat_id: group_chat_id || $user.telegram_id, text:notify_complaint(complaint), parse_mode:'HTML' )
        end
    end
end


