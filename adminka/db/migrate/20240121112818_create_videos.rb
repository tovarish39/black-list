class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.json :oracles_tips
      t.json :lookup_the_counterparty

      t.timestamps
    end
  end
end
