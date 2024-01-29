# frozen_string_literal: true

require_relative 'config'
require_all './bot-main'

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
  bot.listen do |mes|
    $bot = bot # rubocop:disable Style/GlobalVars
    $mes = mes # rubocop:disable Style/GlobalVars

    begin
      handle
    rescue StandardError => e
      # $logger.info("ERROR  #{$mes.inspect}")

      # Send.mes("Error with income json =  \n\n#{$raw_data_for_testing}", to: ENV['CHAT_ID_MY'])
      Send.mes(e, to: ENV['CHAT_ID_MY'])
      Send.mes(e.backtrace, to: ENV['CHAT_ID_MY'])
    end
  end
end
