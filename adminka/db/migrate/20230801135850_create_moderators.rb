class CreateModerators < ActiveRecord::Migration[7.0]
  def change
    create_table :moderators do |t|
      t.string :telegram_id
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :lg
      t.string :state_aasm
      t.string :cur_complaint_id

      t.timestamps
    end
  end
end
