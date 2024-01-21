class AddCompareUserIdToVideo < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :compare_user_id, :json
  end
end
