class AddUserbotPrivateChannelTelegramIdToComplaints < ActiveRecord::Migration[7.0]
  def change
    add_column :complaints, :private_channel_telegram_id, :string
  end
end
