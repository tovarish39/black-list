# frozen_string_literal: true

module M
  module Inline
    IM = ->(buttons) { Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: buttons) }

    def self.lang
      self::IM.call([
                      [IB.ru, IB.en]
                    ])
    end
    def self.moderator_complaint complaint
      self::IM.call([
        [IB.accept_complaint(complaint)],
        [IB.reject_complaint(complaint)]
      ])
      
    end
    def self.view_complaints
      self::IM.call([
        [IB.justification]
      ])
    end
    def self.justification_request_to_moderator user
      self::IM.call([
        [IB.access_justification(user)],
        [IB.block_user(user)]
      ])
    end


  end

  module Reply
    RM = -> (*buttons){ 
      Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: make_objects(buttons), resize_keyboard: true)
    }
    RM_with_user_request = -> (buttons){ 
      Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: buttons, resize_keyboard: true)
    }

    def self.start
      self::RM.call(
        [Button.make_a_complaint],
        [Button.request_status],
        [Button.account_status],
        # [Button.request_history]
      )
    end

    def self.search_user
      self::RM_with_user_request.call([
                                        [{ text: Button.select_user, request_user: { request_id: 111 } }],
                                        [{ text: Button.cancel }]
                                      ])
    end

    def self.user_info
      self::RM.call(
        [Button.verify_potential_scamer],
        [Button.cancel]
      )
    end

    def self.complaint_text
      self::RM.call(
        [Button.cancel]
      )
    end

    def self.complaint_photos
      self::RM.call(
        [Button.ready],
        [Button.cancel]
      )
    end

    def self.compare_user_id
      self::RM.call(
        [Button.skip],
        [Button.cancel]
      )
    end
    def self.greeting_mod
      self::RM.call(
        [Button.active_complaints]
      )
    end

    def self.make_objects(arr)
      arr.map! { |line| line.map! { |but| { text: but } } }
    end
  end
end
