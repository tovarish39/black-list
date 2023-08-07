class UsersController < ApplicationController
require 'telegram/bot'
  
  def index
    @users = User.all.order(:created_at)
    @languages = [
      {label:'ru', value:'ru', checked:true},
      {label:'en', value:'en', checked:false},
      {label:'es', value:'es', checked:false},
    ]
    @status_options = ['scamer', 'not_scamer', 'verified' ]
  end

  def update
    user = User.find(params[:id])
    formatted_new_status = "#{params[:new_status_value]}:managed_by_admin"

    # cброс статусов претезий
    users_complaints = Complaint.where(telegram_id:user.telegram_id)
    
    update_complaints(users_complaints, 'accepted_complaint') if formatted_new_status == 'scamer:managed_by_admin'
    update_complaints(users_complaints, 'rejected_complaint') if formatted_new_status == 'not_scamer:managed_by_admin'
    update_complaints(users_complaints, 'rejected_complaint') if formatted_new_status == 'verified:managed_by_admin'
    
    user.update!(status: formatted_new_status,justification:nil)
    sleep 1 # имитация ожидания

    render json: { updated_status: user.status.split(":").first }
  end

  def send_message
    bot = Telegram::Bot::Client.new(ENV['TOKEN_MAIN'])
    
    ids = params[:checked_ids].keys 
    message = params[:inputValue]
    
    threads = []
    
    ids.each do |id|
      if params[:checked_ids][id] != false
        threads << Thread.new do
          bot = Telegram::Bot::Client.new(ENV['TOKEN_MAIN'])
          user = User.find(id)
    
          begin
            bot.api.send_message(text: message, chat_id: user.telegram_id)
          rescue => e
            Rails.logger.error("Error sending message to user #{id}: #{e.message}")
          end
        end
      end
    end
    sleep 1 # имитация отправки результаты не нужны
    # threads.each(&:join) # Ждем завершения всех потоков
    
    head :ok 
    
  end
  private
  def update_complaints complaints, new_status
    complaints.each {|complaint| complaint.update(status:new_status)} 
  end
end
