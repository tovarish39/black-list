class AddOptionDetailsToComplaints < ActiveRecord::Migration[7.0]
  def change
    add_column :complaints, :option_details, :text
  end
end
