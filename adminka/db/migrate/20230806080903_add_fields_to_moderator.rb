class AddFieldsToModerator < ActiveRecord::Migration[7.0]
  def change
    add_column :moderators, :access_amount, :integer, default: 0
    add_column :moderators, :reject_amount, :integer, default: 0
    add_column :moderators, :block_amount, :integer, default: 0
    add_column :moderators, :decisions_per_day_amount, :integer, default: 0
  end
end
