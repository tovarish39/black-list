class ScamersController < ApplicationController
  require 'dotenv'
  Dotenv.load

  def index
    scamers = User.where("status ~ '^scamer'")
    @scamers = scamers.map do |user|
      complaint = Complaint.where(telegram_id:user.telegram_id).where(status:'accepted_complaint').first
      user_data = user.as_json
      if complaint.present?
        user_data['telegraph_link'] = complaint.telegraph_link 
        user_data['telegram_link'] = "#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}"
      end
      user_data
    end
  end
end
