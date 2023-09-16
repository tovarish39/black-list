class RemoveOptionDetailsFromComplaints < ActiveRecord::Migration[7.0]
  def change
    remove_column :complaints, :option_details, :string
  end
end
