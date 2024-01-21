class AddComplaintTextToVideo < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :complaint_text, :json
  end
end
