class CreateCounters < ActiveRecord::Migration[7.0]
  def change
    create_table :counters do |t|
      t.integer :lookup_requests_from_bots, default: 0

      t.timestamps
    end
  end
end
