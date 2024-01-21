class AddStartToVideo < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :start, :json
  end
end
