# frozen_string_literal: true

# rubocop:disable Style/GlobalVars
# валидации и обработка сообщений из группового чата
module GroupHandler
  # нужен чтобы запоминать когда например делаем /lookup с forwarded сообщениями, чтоб различить их от просто /lookup
  @@checker = {} # rubocop:disable Style/ClassVars
  STOP_STATUSES = %i[scammer suspect].freeze
  class << self
    def message_from_group?
      mes_text? && mes_from_group?
    end

    def handle # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
      user_status = $user.status.to_sym # rubocop:disable Style/GlobalVars
      if STOP_STATUSES.include?(user_status) # сам :scammer или :suspend
        CheckerStatuses.send_stop_status_comment(user_status)
      elsif mes_text?(%r{^/lookup$}) # для следующий пересланных сообщений
        @@checker[:telegram_id] = { pending: :lookup }
      elsif before_forvarted?
        @@checker[:telegram_id] = {}
        handle_text_to_lookup($mes.chat.id)
      elsif mes_text?(%r{^/verify$}) # для следующий пересланных сообщений
        @@checker[:telegram_id] = { pending: :verify }
      elsif before_verify?
        @@checker[:telegram_id] = {}
        handle_forwarded_message_to_verifying
      elsif mes_text?(%r{^/lookup }) # когда после /lookup идёт телеграм ид или юзернейм
        handle_text_to_lookup($mes.chat.id)
      elsif mes_text?(%r{^/verify }) # когда после /verify идёт телеграм ид или юзернейм
        handle_verify_with_id_or_username
      end
    end

    def before_verify?
      # $verifing && $is_next_forward_message && ($forwarder_user_telegram_id == $mes.from.id) && $mes.forward_from.present?
      user_local = @@checker[:telegram_id]
      return false unless user_local

      user_local[:pending] == :verify && $mes.forward_from.present?
    end

    def before_forvarted?
      # $lookuping && $is_next_forward_message && ($forwarder_user_telegram_id == $mes.chat.id) && $mes.forward_from.present?
      user_local = @@checker[:telegram_id]
      return false unless user_local

      user_local[:pending] == :lookup && $mes.forward_from.present?
    end

    def handle_verify_with_id_or_username
      data = $mes.text.split(' ')[1]
      user = if data =~ /^\d+$/ # telegram_id
               User.find_by(telegram_id: data)
             else # username
               User.find_by(username: data.sub('@', ''))
             end
      result_of_verifying(user, data)
    end

    def handle_forwarded_message_to_verifying
      checking_telegram_id = $mes.forward_from.id
      user = User.find_by(telegram_id: checking_telegram_id)
      result_of_verifying(user, checking_telegram_id)
    end

    def result_of_verifying(user, data)
      CheckerStatuses.view_status(user, data)
    end
  end
end
# rubocop:enable Style/GlobalVars
