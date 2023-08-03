require './config/requires.rb'
require_all './bot-main'

log_path = "#{$root_path}/log/bot-main.log"
$logger = Logger.new(log_path, 'weekly')
$logger.formatter = proc do |severity, datetime, _progname, msg|
  date_format = datetime.strftime('%Y-%m-%d %H:%M:%S')
  "#{severity.slice(0)} date=[#{date_format}] pid=##{Process.pid} message='#{msg}'\n"
end

Telegram::Bot::Client.run(ENV['TOKEN_MAIN']) do |bot|
  bot.listen do |message|
    $bot = bot 
    $mes = message 

    handle if $mes
    # rescue  => e
    #   Send.mes(e, to: ENV['CHAT_ID_MY'])
    #   Send.mes(e.backtrace, to: ENV['CHAT_ID_MY'])
  end
end
