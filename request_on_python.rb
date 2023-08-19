require './config/requires.rb'

def is_telegram_id text
    text =~ /^\d+$/ 
end

def is_username
    !is_telegram_id
end



data = ARGV[0]
from_user_telegram_id = ARGV[1]

user_request_from = User.find_by(telegram_id:from_user_telegram_id)




puts data
puts user_request_from