# frozen_string_literal: true

class UsersController < ApplicationController # rubocop:disable Style/Documentation
  require 'telegram/bot'

  def index
    @users = User.all.order(:created_at)
    @languages = languages
    @status_options = status_options
    @complaints_per_day, @complaints_per_week, @complaints_per_month = complaints_per_time
    @lookup_counter = Counter.last.lookup_requests_from_bots
  end

  def update # rubocop:disable Metrics/MethodLength
    user = User.find(params[:id])
    status = params[:new_status_value]

    reset_users_complaints(user, status)

    args = {
      status:,
      justification: nil,
      managed_status_by: 'admin'
    }
    args[:date_when_became_a_scamer] = DateTime.now if status == :scammer
    user.update!(args)
    sleep 1 # имитация ожидания

    render json: { updated_status: user.status }
  end

  def send_message # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
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
    complaints.each do |complaint|
      complaint.update(status: new_status) if complaint.status != 'filling_by_user'
    end
  end

  def languages
    [
      { label: 'ru', value: 'ru', checked: true },
      { label: 'en', value: 'en', checked: false },
      { label: 'es', value: 'es', checked: false },
      { label: 'cn', value: 'cn', checked: false }
    ].freeze
  end

  def complaints_per_time # rubocop:disable Metrics/AbcSize
    complaints = Complaint.where.not(status: 'filling_by_user')
    complaints.each_with_object([0, 0, 0]) do |complaint, acc|
      created_at = complaint.created_at
      acc[0] = acc[0] + 1 if created_at > 1.day.ago
      acc[1] = acc[1] + 1 if created_at > 1.week.ago
      acc[2] = acc[2] + 1 if created_at > 1.month.ago
    end
  end

  def status_options
    # rubocop:disable  Layout/ExtraSpacing
    [
      { label: '💤 Regular User',            value: 'start_default' },
      { label: '⚠️ Suspect',                  value: 'suspect' },
      { label: '🚫 Scammer/Ripper',          value: 'scammer' },
      { label: '✅ Oracle Verified',         value: 'verified' },
      { label: '🔱 Trusted',                 value: 'trusted' },
      { label: '♨️ DWC',                      value: 'dwc' },
      { label: '✅ ⚠️ Oracle Trial Verified', value: 'trial_verified' },
      { label: '🌐 Federal Admin',           value: 'federal_admin' }
    ]
    # rubocop:enable  Layout/ExtraSpacing
  end

  def reset_users_complaints(user, user_status)
    complaints = Complaint.where(telegram_id: user.telegram_id)
    stop_statuses = %w[suspect scammer]
    complaint_status = stop_statuses.include?(user_status) ? 'accepted_complaint' : 'rejected_complaint'
    update_complaints(complaints, complaint_status)
  end
end
