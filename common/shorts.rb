module Chat_id
    def self.telegram_id
        $mes.class == Message ? $mes.chat.id : $mes.message.chat.id
    end
end


module Send
    def self.mes text, reply_markup = nil, to: Chat_id
        $bot.api.send_message(
            chat_id: (to.class == String) ? ENV['CHAT_ID_MY'] : to.telegram_id , 
            text:text, reply_markup:reply_markup, parse_mode:"HTML")
    end 
end

module Delete
    def self.text
        $bot.api.delete_message(chat_id:Chat_id, message_id:$mes.message_id)
    end
    def self.pushed message_id = $mes.message.message_id
        $bot.api.delete_message(chat_id:Chat_id, message_id:message_id)
    end
end

module Edit
    def self.mes text, reply_markup = nil, message_id = nil
        message_id ||= $mes.message.message_id
        $bot.api.edit_message_text(chat_id:Chat_id, message_id:message_id, text:text, reply_markup:reply_markup, parse_mode:"HTML")        
    end
end

module GetChat
    def self.info chat_id
        $bot.api.get_chat(chat_id:chat_id)
    end
end

module Get
    def self.file file_id
        $bot.api.get_file(file_id: file_id)
    end
end

def get_photo_dir_path complate
    "#{PHOTOS_PATH}/#{complate.id}-#{complate.telegram_id}"
end

def action(from_state) = "#{from_state}_action"        

def mes_photo?
    return false unless $mes.class == Message
    $mes.photo.present?
end

def mes_from_group_and_text?
    mes_text? &&  $mes.chat.type == 'group'
end

def mes_text? compare = nil # сообщение text любое или соответствие сравниваемому
    return false if $mes.class != Message
    return nil if !$mes.text # для кнопки shared_user
    text = $mes.text
    comparing(text, compare)
 end
 
 def mes_data?(compare = nil) # сообщение callback любое или соответствие сравниваемому
   return false if $mes.class != CallbackQuery
   data = $mes.data
   comparing(data, compare)
 end

 def comparing message, compare
  return true if !compare
  with_text  = compare.class == String
  with_regex = compare.class == Regexp 
  return true if with_text  && message == compare
  return true if with_regex && message =~ compare
  false
end