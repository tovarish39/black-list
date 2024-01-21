class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :telegram_id
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :lg
      t.string :state_aasm
      t.string :cur_complaint_id
      t.string :cur_message_id
      t.string :status, default: 'not_scamer:default'
      t.string :complaint_id
      t.text :justification

      t.timestamps
    end
  end
end
