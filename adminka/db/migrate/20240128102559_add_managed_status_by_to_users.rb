class AddManagedStatusByToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :managed_status_by, :string
  end
end
