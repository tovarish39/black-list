class AddInputUsernameToVideo < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :input_username, :json
  end
end
