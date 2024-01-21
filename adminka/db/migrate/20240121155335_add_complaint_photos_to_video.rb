class AddComplaintPhotosToVideo < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :complaint_photos, :json
  end
end
