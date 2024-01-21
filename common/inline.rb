module IB
  IB = lambda { |text, callback_data|
    Telegram::Bot::Types::InlineKeyboardButton.new(text:, callback_data:)
  }

  def self.ru = IB.call(Button.ru, "#{Ru}/lg")
  def self.en = IB.call(Button.en, "#{En}/lg")
  def self.es = IB.call(Button.es, "#{Es}/lg")
  def self.cn = IB.call(Button.cn, "#{Cn}/lg")

  def self.accept_complaint(complaint)
    IB.call(Button.accept, "#{complaint.id}/accept_complaint")
  end

  def self.reject_complaint(complaint)
    IB.call(Button.reject, "#{complaint.id}/reject_complaint")
  end

  def self.justification
    IB.call(Button.justification, 'Оспорить_justification')
  end

  def self.access_justification(user)
    IB.call(Button.accept, "#{user.id}/access_justification")
  end

  def self.block_user(user)
    IB.call(Button.block_user, "#{user.id}/block_user")
  end

  def self.link_to_support
    Telegram::Bot::Types::InlineKeyboardButton.new(text: Button.support_inline, url: ENV['SUPPORT_PATH'])
  end

  def self.link_to_oracles_tips
    Telegram::Bot::Types::InlineKeyboardButton.new(text: Button.oracle_tips_inline,
                                                   url: ENV['ORACLES_TIPS_PATH'])
  end
end
