class ScamersController < ApplicationController
  def index
    scamers = User.where("status LIKE ? AND status NOT LIKE ?", "scamer%", "not_scamer%")
    @scamers = scamers.map do |user|
      user_data = user.as_json
      user_data['telegraph_post'] = 'plug'  # Замените на реальное значение
      user_data['telegram_post'] = 'plug'  # Замените на реальное значение
      user_data
    end
  end
end
