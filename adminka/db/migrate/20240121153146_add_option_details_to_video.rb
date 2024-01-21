class AddOptionDetailsToVideo < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :option_details, :json
  end
end
