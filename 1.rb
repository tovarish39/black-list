require 'telegram/bot'
require 'dotenv'
Dotenv.load


def user_is_member_of_channel?
    begin
    res = $bot.api.getChatMember(chat_id: ENV['TELEGRAM_CHANNEL_ID'], user_id: $mes.from.id)
    rescue  => e
        puts 'include bot as administrator of channel'
    end
    status = res['result']['status']
    return true if status == 'member' || status == 'creator' # !'left' !'kicked'
    false
  end
  

Telegram::Bot::Client.run(ENV['TOKEN_MAIN']) do |bot|
    bot.listen do |message|
      $bot = bot 
      $mes = message 

puts      user_is_member_of_channel?

    end
  end