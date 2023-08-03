class CreateComplaints < ActiveRecord::Migration[7.0]
  def change
    create_table :complaints do |t|
      t.references :user, null: false, foreign_key: true
      t.string :telegram_id
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :status, default: 'filling_by_user'
      t.string :photos_dir_path
      t.text :complaint_text
      t.integer :photos_amount
      t.boolean :is_proofed_by_forwarted_mes
      t.string :telegraph_link
      t.text :explanation_by_moderator
      t.string :photo_urls_remote_tmp, array:true
      t.string :mes_id_published_in_channel


      t.timestamps
    end
  end
end
