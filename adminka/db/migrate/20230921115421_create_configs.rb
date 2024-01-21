class CreateConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :configs do |t|
      t.string :for_private_channel_video_file_ids, array: true, default: []

      t.timestamps
    end
  end
end
