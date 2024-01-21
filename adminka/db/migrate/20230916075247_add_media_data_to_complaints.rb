class AddMediaDataToComplaints < ActiveRecord::Migration[7.0]
  def change
    add_column :complaints, :media_data, :json, default: { texts: [], voice_file_ids: [], video_note_file_ids: [] }
  end
end
