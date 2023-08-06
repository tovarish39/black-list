class AddDateWhenBecameAScamerToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :date_when_became_a_scamer, :datetime
  end
end
