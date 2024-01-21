class AddSearchUserToVideo < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :search_user, :json
  end
end
