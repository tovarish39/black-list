# frozen_string_literal: true

require 'net/http'
require 'json'
require 'nokogiri'
require 'telegram/bot'

require_relative 'config'
# Dotenv.load
complaint_id = ARGV[0]
user_id   =  ARGV[1]

complaint = Complaint.find(complaint_id)
user = User.find(user_id) # userFrom
userTo = if complaint.telegram_id.present?
           User.find_by(telegram_id: complaint.telegram_id)
         else
           User.find_by(username: complaint.username)
         end

access_token = '17bfdc2d653bbef801cfbb3c3caff533b4011513e06dfefad55b87178a81'

def create_page(title, content, access_token)
  uri = URI('https://api.telegra.ph/createPage')
  response = Net::HTTP.post_form(uri, {
                                   'title' => title,
                                   'content' => content,
                                   'access_token' => access_token,
                                   'author_url' => ENV['MAIN_BOT_LINK'],
                                   'author_name' => 'black-list-bot'
                                 })
  JSON.parse(response.body)
end

title = "NEW REPORT ##{complaint.id}"
# content = %Q{[
#     {"tag":"p","children":["Приветствие!"]}
# }
title_image_telegraph_url = 'https://telegra.ph/file/b3a08cf6a1f45940acf92.png'
content = %([
    {"tag":"img", "attrs":{"src":"#{title_image_telegraph_url}"}}
)

complaint.photo_urls_remote_tmp.each do |url|
  img = %(
        ,{"tag":"img", "attrs":{"src":"#{url}"}}
    )
  content << img
end

user_info = "Telegram ID : #{complaint.telegram_id}"
user_info << "\nUsername : @#{complaint.username}" if complaint.username.present?
user_info << "\nFirst_name : #{complaint.first_name}" if complaint.first_name.present?
user_info << "\nLast_name : #{complaint.last_name}" if complaint.last_name.present?

complaint_text = complaint.complaint_text
# complaint_text = "Complaint : #{complaint.complaint_text}"

# content << %Q{
#     ,{"tag":"p","children":["#{user_info}"]}
# }
content << %(
         ,{"tag":"p","children":["REPORT REASON:"]}
     )

content << %(
    ,{"tag":"p","children":["#{complaint_text}"]}
)

content << %(
    ,{"tag":"br"}
    ,{"tag":"br"}
    ,{"tag":"a","attrs":{"href":"#{ENV['ORACLE_LIST']}"},"children":["@oraclelist"]},{"tag":"p","children":[" - the brand new international rippers list"]}
    ,{"tag":"a","attrs":{"href":"#{ENV['ORACLE_NEWS']}"},"children":["@oraclesnews"]},{"tag":"p","children":[" - one-stop spot for all telegram, crypto and fraud related news in 3 languages"]}
    ,{"tag":"a","attrs":{"href":"#{ENV['ORACLE_MARKET']}"},"children":["@oraclesmarket"]},{"tag":"p","children":[" - only verified sellers market"]}

)

content << ']'

response = create_page(title, content, access_token)
telegraph_link = response['result']['url']
complaint.update(
  telegraph_link:,
  status: 'request_to_moderator'
)

sended_mes_id = user.cur_message_id

def complaint_request_to_moderator(complaint, user)
  if user.lg == Ru
    return "Ваша жалоба #N#{complaint.id} была успешно подана и в настоящее время ожидает рассмотрения. Вы будете уведомлены, как только будет принято решение."
  end
  if user.lg == En
    return "Your report #N#{complaint.id} has been successfully submitted and is currently awaiting review. You will be notified as soon as a decision has been made."
  end
  if user.lg == Es
    return "Tu informe #N#{complaint.id} se ha enviado con éxito y está esperando revisión. Se te notificará tan pronto como se tome una decisión."
  end

  "您的报告＃N#{complaint.id}已成功提交，目前正在等待审查。一旦做出决定，您将立即收到通知。" if user.lg == Cn
end

begin
  main_bot = Telegram::Bot::Client.new(ENV['TOKEN_MAIN'])
  ###################### из Text.

  main_bot.api.edit_message_text(
    chat_id: user.telegram_id,
    text: complaint_request_to_moderator(complaint, user), #  "Ваша жалоба #N#{complaint.id} была отправлена на проверку модератором, ожидайте её рассмотрения о результатах вас оповестит бот",
    message_id: sended_mes_id
  )
rescue StandardError => e
  main_bot.api.send_message(text: e, chat_id: ENV['CHAT_ID_MY'])
end

bot = Telegram::Bot::Client.new(ENV['TOKEN_MODERATOR'])
moderators = Moderator.all
moderators.each do |moderator|
  mes = bot.api.send_message(
    text: Text.moderator_complaint(user, userTo, complaint),
    chat_id: moderator.telegram_id,
    reply_markup: M::Inline.moderator_complaint(complaint),
    parse_mode: 'HTML'
  )
rescue StandardError => e
  if e.error_code != 400
    bot.api.send_message(text: "telegraph #{e}", chat_id: ENV['CHAT_ID_MY'])
    bot.api.send_message(text: e.backtrace, chat_id: ENV['CHAT_ID_MY'])
  end
end
