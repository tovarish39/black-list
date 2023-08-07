class AddHandledModeratorIdToComplaints < ActiveRecord::Migration[7.0]
  def change
    add_column :complaints, :handled_moderator_id, :string
  end
end
