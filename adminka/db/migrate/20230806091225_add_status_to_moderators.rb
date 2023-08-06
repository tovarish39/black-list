class AddStatusToModerators < ActiveRecord::Migration[7.0]
  def change
    add_column :moderators, :status, :string, default:'active'
  end
end
