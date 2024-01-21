class UsersController < ApplicationController
  require 'telegram/bot'

  def index
    @users = User.all.order(:created_at)
    @languages = [
      { label: 'ru', value: 'ru', checked: true },
      { label: 'en', value: 'en', checked: false },
      { label: 'es', value: 'es', checked: false },
      { label: 'cn', value: 'cn', checked: false }
    ]
    @status_options = %w[scamer not_scamer verified trusted dwc]

    complaints_for_statistic = Complaint.where.not(status: 'filling_by_user')
    @complaints_per_day = []
    @complaints_per_week = []
    @complaints_per_month = []
    complaints_for_statistic.each do |complaint|
      @complaints_per_day   << complaint if complaint.created_at > 1.day.ago
      @complaints_per_week  << complaint if complaint.created_at > 1.week.ago
      @complaints_per_month << complaint if complaint.created_at > 1.month.ago
    end
    counter = Counter.first
    counter ||= Counter.create
    @lookup_counter = counter.lookup_requests_from_bots
  end

  def update
    user = User.find(params[:id])
    formatted_new_status = "#{params[:new_status_value]}:managed_by_admin"

    # cброс статусов претезий
    users_complaints = Complaint.where(telegram_id: user.telegram_id)

    update_complaints(users_complaints, 'accepted_complaint') if formatted_new_status == 'scamer:managed_by_admin'
    update_complaints(users_complaints, 'rejected_complaint') if formatted_new_status == 'not_scamer:managed_by_admin'
    update_complaints(users_complaints, 'rejected_complaint') if formatted_new_status == 'verified:managed_by_admin'
    update_complaints(users_complaints, 'rejected_complaint') if formatted_new_status == 'trusted:managed_by_admin'
    update_complaints(users_complaints, 'rejected_complaint') if formatted_new_status == 'dwc:managed_by_admin'

    user.update!(date_when_became_a_scamer: DateTime.now) if formatted_new_status == 'scamer:managed_by_admin'

    user.update!(status: formatted_new_status, justification: nil)
    sleep 1 # имитация ожидания

    render json: { updated_status: user.status.split(':').first }
  end

  def send_message
    bot = Telegram::Bot::Client.new(ENV['TOKEN_MAIN'])

    ids = params[:checked_ids].keys
    message = params[:inputValue]

    threads = []

    ids.each do |id|
      next unless params[:checked_ids][id] != false

      threads << Thread.new do
        bot = Telegram::Bot::Client.new(ENV['TOKEN_MAIN'])
        user = User.find(id)

        begin
          bot.api.send_message(text: message, chat_id: user.telegram_id)
        rescue StandardError => e
          Rails.logger.error("Error sending message to user #{id}: #{e.message}")
        end
      end
    end
    sleep 1 # имитация отправки результаты не нужны
    # threads.each(&:join) # Ждем завершения всех потоков

    head :ok
  end

  private

  def update_complaints(complaints, new_status)
    complaints.each { |complaint| complaint.update(status: new_status) }
  end
end
