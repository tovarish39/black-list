require './config/requires'
require_all './bot-main'

BOT_MOD_INIT = Telegram::Bot::Client.new(ENV['TOKEN_MODERATOR'])
BOT_MAIN_INIT = Telegram::Bot::Client.new(ENV['TOKEN_MAIN'])

log_path = "#{$root_path}/log/bot-main.log"
$logger = Logger.new(log_path, 'weekly')
$logger.formatter = proc do |severity, datetime, _progname, msg|
  date_format = datetime.strftime('%Y-%m-%d %H:%M:%S')
  "#{severity.slice(0)} date=[#{date_format}] pid=##{Process.pid} message='#{msg}'\n"
end

# def get_logger(_user)
#   log_path = "#{ENV['GARANT_ROOT_PATH']}/logs/#{$user.telegram_id}_#{$user.username}.log"
#   logger = Logger.new(log_path, 'monthly')
#   logger.formatter = proc do |severity, datetime, _progname, msg|
#     date_format = datetime.strftime('%Y-%m-%d %H:%M:%S')
#     "#{severity.slice(0)} [#{date_format}] pid=#{Process.pid} data='#{msg}'\n"
#   end
#   logger
# end

Telegram::Bot::Client.run(ENV['TOKEN_MAIN']) do |bot|
  bot.listen do |message|
    $bot = bot
    $mes = message

    begin
      handle if $mes
    rescue StandardError => e
      $logger.info("ERROR  #{$mes.inspect}")
      Send.mes(e, to: ENV['CHAT_ID_MY'])
      Send.mes(e.backtrace, to: ENV['CHAT_ID_MY'])
    end
  end
end
