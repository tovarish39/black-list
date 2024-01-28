# frozen_string_literal: true

require_relative 'config'

require_all './bot-moderator'

log_path = "#{$root_path}/log/bot-moderator.log"
$logger = Logger.new(log_path, 'weekly')
$logger.formatter = proc do |severity, datetime, _progname, msg|
  date_format = datetime.strftime('%Y-%m-%d %H:%M:%S')
  "#{severity.slice(0)} date=[#{date_format}] pid=##{Process.pid} message='#{msg}'\n"
end

# counter = 0
Telegram::Bot::Client.run(ENV['TOKEN_MODERATOR']) do |bot|
  bot.listen do |message|
    $bot = bot
    $mes = message

    $logger.info("BEFORE ; mes = #{$mes.inspect}")

    begin
      handle if $mes
    rescue StandardError => e
      $logger.error('ERR')
      Send.mes(e, to: ENV['CHAT_ID_MY'])
      Send.mes(e.backtrace, to: ENV['CHAT_ID_MY'])
    end
    # $logger.info("end   handle ; counter = #{counter}")
    # counter += 1
  end
end
