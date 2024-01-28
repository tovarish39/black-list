# frozen_string_literal: true

module CheckerStatuses # rubocop:disable Style/Documentation
  class << self
    def send_stop_status_comment(status)
      text_first = I18n.t("stop_status_comment.#{status}")
      BotMain.send_message(reply_to_message_id: $mes.message_id, text: text_first)
      accepted_complaint = Complaint.find_by(telegram_id: $user.telegram_id, status: :accepted_complaint)
      return unless accepted_complaint

      text_second = String.new
      text_second << "\n#{Link.stop_status_1(accepted_complaint.telegraph_link)}" if accepted_complaint.telegraph_link.present? # rubocop:disable Layout/LineLength
      text_second << "\n#{Link.stop_status_2}" if status == :suspect
      text_second << "\n#{Link.stop_status_3}"
      BotMain.send_message(text: text_second)
    end

    def view_status(user, data, chat_id: nil)
      status = user.nil? ? :start_default : user.status

      text = String.new
      text << (user.nil? ? data : Text.user_info(user))
      text << "\n#{I18n.t("user.status.#{status}")}"
      text << "\n"
      text << "\n<a href='#{ENV['ORACLE_LIST']}'>@oraclelist</a>"
      BotMain.send_message(text:, chat_id:)
    end
  end
end

# rubocop:disable
# def self.verifying_user(user, status, data = nil)
# formatted_status =
#   if $lg == Ru && status == 'scamer'
#     '🚫 Кидок.'
#   elsif $lg == Ru && status == 'not_scamer'
#     '✅ Мужик (не кидок).'
#   elsif $lg == Ru && status == 'verified'
#     '⚜️ Верифицированный.'
#   elsif $lg == Ru && status == 'trusted'
#     '🔱 Доверенный.'
#   elsif $lg == Ru && status == 'dwc'
#     '☢️ Проявите осторожность! .'
#   elsif $lg == En && status == 'scamer'
#     '🚫 Ripper.'
#   elsif $lg == En && status == 'not_scamer'
#     '✅ Not a ripper.'
#   elsif $lg == En && status == 'verified'
#     '⚜️ Verified.'
#   elsif $lg == En && status == 'trusted'
#     '🔱 trusted.'
#   elsif $lg == En && status == 'dwc'
#     '☢️ DWC.'
#   elsif $lg == Es && status == 'scamer'
#     '🚫 Ripper.'
#   elsif $lg == Es && status == 'not_scamer'
#     '✅ No es una ripper.'
#   elsif $lg == Es && status == 'verified'
#     '⚜️ Verificado.'
#   elsif $lg == Es && status == 'trusted'
#     '🔱 trusted.'
#   elsif $lg == Es && status == 'dwc'
#     '☢️ Tratar con precaución.'
#   elsif $lg == Cn && status == 'scamer'
#     '🚫 骗子.'
#   elsif $lg == Cn && status == 'not_scamer'
#     '✅ 不是骗局.'
#   elsif $lg == Cn && status == 'verified'
#     '⚜️ 已验证.'
#   elsif $lg == Cn && status == 'trusted'
#     '🔱 可信任的.'
#   elsif $lg == Cn && status == 'dwc'
#     '☢️ 谨慎处理.'
#   end
#   if $lg.present?
#     text = ''
#     text << "#{data}" if user.nil?
#     text << "\n#{Text.user_info(user)}" if user.present?
#     text << "\n#{formatted_status} <a href='#{ENV['ORACLE_LIST']}'>@oraclelist</a>"
#     # text << "\n#{formatted_status} <a href='https://t.me/ripperlistbot'>@oraclelist</a>"

#     text
#   elsif $lg.nil? && status == 'scamer' # когда в других группах в любых, где язык не опрделён
#     complaint = Complaint.find_by(telegram_id: user.telegram_id)
#     text = ''
#     text << "#{data}" if user.nil?
#     text << "\n#{Text.user_info(user)}" if user.present?
#     text << "\nripper / кидала / 骗子" if status == 'scamer'
#     text << "\n<a href='#{ENV['MAIN_BOT_LINK']}'>APPEAL  / ОБЖАЛОВАТЬ / 上诉 / APELACIÓN</a>"
#     if complaint && complaint.mes_id_published_in_channel
#       text << "\n<a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>report</a>\n\n"
#     end
#     text << "\n<a href='#{ENV['ORACLE_LIST']}'>@oraclelist</a>"
#     # text << "\n<a href='https://t.me/ripperlistbot'>@oraclelist</a>"

#     text
#   end
# end
