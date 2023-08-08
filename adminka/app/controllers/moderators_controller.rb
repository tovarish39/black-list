class ModeratorsController < ApplicationController
  def index
    @moderators = Moderator.all.order(created_at: :desc)
    @status_options = ['active', 'inactive' ]
  end

  def create
    new_telegram_id = params[:telegram_id]
    is_exist = Moderator.find_by(telegram_id:new_telegram_id).present?
    Moderator.create(telegram_id:params[:telegram_id]) if !is_exist
    sleep 1 # имитация ожидания
    head :ok
  end

  def update
    moderator = Moderator.find(params[:id])
    moderator.update!(status: params[:new_status_value])
    sleep 1 # имитация ожидания

    render json: { updated_status: moderator.status }
  end

  def send_message
    
    ids = params[:checked_ids].keys 
    message = params[:inputValue]
    
    threads = []
    
    ids.each do |id|
      if params[:checked_ids][id] != false
        threads << Thread.new do
          bot = Telegram::Bot::Client.new(ENV['TOKEN_MODERATOR'])
          user = Moderator.find(id)
    
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
end
