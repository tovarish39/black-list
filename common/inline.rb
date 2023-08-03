module IB
    IB = -> (text, callback_data) { 
        Telegram::Bot::Types::InlineKeyboardButton.new(text: text, callback_data: callback_data)
      }

    def self.ru = IB.call(Button.ru, "#{Ru}/lg")     
    def self.en = IB.call(Button.en, "#{En}/lg")   
      
    def self.accept_complaint complaint
      IB.call(Button.accept, "#{complaint.id}/accept_complaint") 
    end
    def self.reject_complaint scamer
      IB.call(Button.reject, "#{scamer.id}/reject_complaint")       
    end
    def self.justification
      IB.call(Button.justification, "Оспорить_justification")       
    end
    def self.access_justification user
      IB.call(Button.accept, "#{user.id}/access_justification")       
    end
    def self.block_user user
      IB.call(Button.block_user, "#{user.id}/block_user")             
    end
end