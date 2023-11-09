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
    # puts exception
end

def delete_text_after_char str, char
    last_index = str.rindex(char)
    str.slice(0,last_index + 1)
end


def formating_month old_month
    case old_month
    when 'янв'; "01"#
    when 'фев'; "02"#
    when 'мар'; "03"
    when 'апр'; "04"
    when 'май'; "05"
    when 'июн'; "06"#
    when 'июл'; "07"#
    when 'авг'; "08"#
    when 'сен'; "09"
    when 'окт'; "10"#
    when 'ноя'; "11"#
    when 'дек'; "12"#
    end
end

def date_formatting line
    old_date = line.split('≈').last
    old_month = old_date.split(',').first
    year = old_date.split(' ').first.split(',').last
    years_amount = old_date.split('(').last.split(' ').first
    month = formating_month(old_month)
    years_text = years_amount.to_i > 1 ? "years" : "year" 
    "#{month}/#{year} (#{years_amount} #{years_text})"
end

def to_UTF8 text
    text.force_encoding('UTF-8').encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
end

def formatting_lines lines
    stop_words = ['Телефон', 'Возможные сервера']
    change_words = [
        { exist: 'Регистрация', new: 'Account Creation Date' },
        { exist: 'Изменения профиля', new: 'Profile changes' },
    ]
    new_lines = []
    lines.each do |line|
        next if  line.nil? || line.empty? 
        formatted_line = to_UTF8(line)
        is_in_stop = false
# удаление лишних строк
        stop_words.each do |word| 
            is_in_stop = true if formatted_line.include?(word)
        end
# изменение языка слов
        change_words.each do |word|
            if  formatted_line.include?(word[:exist])
                if word[:exist] == 'Регистрация'
# изменение даты регистрации
                    formatted_date = date_formatting(formatted_line)
                    formatted_line = formatted_line.gsub('`', '')
                    formatted_line =  formatted_line.split('≈').first + "≈" + formatted_date
                end
                formatted_line = formatted_line.gsub(word[:exist], word[:new])
            end
        end 
        new_lines.push(formatted_line) if !is_in_stop
    end
    new_lines
end

def format_res res 
    # задача перевести на английский
    # убрать не нужные строки
    utf8 = to_UTF8(res)
    lines = utf8.split("\n")

    new_lines = [lines[0], lines[1]] # первые 2-е всегда нужны
    # need_words_in_line = ['Изменения профиля', 'Регистрация']

    flag = false
    lines.each do |line|
        new_lines.push(line) if line.include?('Регистрация')

        if flag && !line.empty? # строки после 'Изменения профиля'
            new_lines.push(line)
        else flag = false
        end

        if line.include?('Изменения профиля')
            new_lines.push(line)
            flag = true
        end


    end
    # if utf8.include?('Изменения профиля')
    #     # когда есть 'Изменения профиля'
    #     text =  delete_text_after_char(res, '|')
    # end
    
    # # когда нету 'Изменения профиля'
    # lines = text&.split("\n") || res.split("\n")
    
    # if !utf8.include?('Изменения профиля')
    #     lines = lines.slice(0, 3)
    # end


    formatted_lines = formatting_lines(new_lines)
    formatted_lines.join("\n")
end

result_message = (response.present? && response == 'Error') || format_res(response).include?('Запрос принят, ожидайте') ?  
    Text.not_availible : 
    format_res(response)

answer = if result_message.include?('_')
            result_message.gsub(/_/, '\\\\_')
         else 
            result_message
         end


bot.api.delete_message(chat_id: group_chat_id|| $user.telegram_id,  message_id:message_id)
bot.api.send_message(chat_id: group_chat_id || $user.telegram_id,  text:answer, parse_mode:'Markdown')
def notify_scammer
    return '🚩 Ваш контрагент обнаружен в списке кидков!' if $lg == Ru
    return '🚩 Your counterparty has been found on the scam list!' if $lg == En
    return '🚩 ¡Su contratante ha sido encontrado en la lista de estafadores!' if $lg == Es
    return '🚩 您的交易对手被发现在骗子名单上！' if $lg == Cn
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






#  /verifying by id | username


def result_of_verifying_local user, group_chat_id, data, bot
#   puts user
# puts data
  if user.present? && user.status =~ /^scamer/
    bot.api.send_message(chat_id: group_chat_id || $user.telegram_id,  text:Text.verifying_user(user, 'scamer', data), parse_mode:'HTML')
  elsif user.present? && user.status =~ /^verified/
    bot.api.send_message(chat_id: group_chat_id || $user.telegram_id,  text:Text.verifying_user(user, 'verified', data), parse_mode:'HTML')
  elsif user.present?  && user.status =~ /^not_scamer/
    bot.api.send_message(chat_id: group_chat_id || $user.telegram_id,  text:Text.verifying_user(user, 'not_scamer', data), parse_mode:'HTML')
  elsif user.nil?
    bot.api.send_message(chat_id: group_chat_id || $user.telegram_id,  text:Text.verifying_user(user, 'not_scamer', data), parse_mode:'HTML')
  elsif user.present? && user.status =~ /trusted/
    bot.api.send_message(chat_id: group_chat_id || $user.telegram_id,  text:Text.verifying_user(user, 'trusted', data), parse_mode:'HTML')
  elsif user.present? && user.status =~ /dwc/
    bot.api.send_message(chat_id: group_chat_id || $user.telegram_id,  text:Text.verifying_user(user, 'dwc', data), parse_mode:'HTML')
  end
end
def handle_verify_with_id_or_username data, group_chat_id, bot
  user = if data =~ /^-?\d+$/ # telegram_id
           User.find_by(telegram_id:data)
         else # username
           User.find_by(username:data.sub('@', ''))
         end
         result_of_verifying_local(user, group_chat_id, data, bot)
end

handle_verify_with_id_or_username(data, group_chat_id, bot)