# frozen_string_literal: true

# rubocop:disable Style/GlobalVars

# дефолтный чат ид. чтоб отправлять туда откуда пришло сообщение
module Chat
  def self.to_self
    if $mes.instance_of?(CallbackQuery)
      $mes.message.chat.id
    else
      $mes.chat.id
    end
  end
end

# сокращения ответов бота юзеру
module BotMain
  class << self
    def get_message_id(mes)
      if mes.instance_of?(CallbackQuery)
        mes.message.message_id
      else
        mes.message_id
      end
    end

    def send_message(args)
      # default args
      bot = BOT_MAIN_INIT
      args[:chat_id]    ||= Chat.to_self
      args[:parse_mode] ||= 'HTML'

      bot.api.send_message(args)
    end

    def edit_message_text(text, reply_markup = nil, message_id: nil, chat_id: nil, bot: BOT_MAIN_INIT)
      message_id ||= get_message_id($mes)
      chat_id ||= Chat.to_self

      bot.api.edit_message_text(chat_id:, message_id:, text:, reply_markup:,
                                parse_mode: 'HTML')
    rescue StandardError => e
      send_message(text, reply_markup, chat_id)
      send_message(
        "не получилось изменить сообщение, пришлось отправить \n#{e}",
        chat_id: ENV['CHAT_ID_MY']
      )
    end

    def delete_message(message_id: nil, bot: BOT_MAIN_INIT)
      message_id ||= get_message_id($mes)
      bot.api.delete_message(chat_id: Chat.to_self, message_id:)
    rescue StandardError => e
      send_message(
        "не получилось удалить сообщение \n#{e}",
        chat_id: ENV['CHAT_ID_MY']
      )
    end

    def send_animation(caption:, reply_markup:, file_id:, bot: BOT_MAIN_INIT)
      bot.api.send_animation(chat_id: Chat.to_self, animation: file_id, reply_markup:, caption:, parse_mode: 'HTML')
    end

    def send_video(caption:, reply_markup:, file_id:, bot: BOT_MAIN_INIT)
      bot.api.send_video(chat_id: Chat.to_self, video: file_id, reply_markup:, caption:, parse_mode: 'HTML')
    end
    # def send_animation(file_id:, bot: BOT_MAIN_INIT)
    #   bot.api.send_animation(chat_id: Chat.to_self, animation: file_id)
    # end
  end
end

# сокращения ответов модератора-бота модератору
module BotMod
  def self.send_message(text, reply_markup = nil, chat_id: nil, bot: BOT_MOD_INIT)
    BotMain.send_message(text, reply_markup, chat_id:, bot:)
  end

  def self.edit_message_text(text, reply_markup = nil, message_id: nil, chat_id: nil, bot: BOT_MOD_INIT)
    BotMain.edit_message_text(text, reply_markup, message_id:, chat_id:, bot:)
  end

  def self.delete_message(message_id: nil, bot: BOT_MOD_INIT)
    BotMain.delete_message(message_id:, bot:)
  end
end

# rubocop:enable Style/GlobalVars
