class AddPhotoFileIdsToComplaints < ActiveRecord::Migration[7.0]
  def change
    add_column :complaints, :photo_file_ids, :string, array: true
  end
end
