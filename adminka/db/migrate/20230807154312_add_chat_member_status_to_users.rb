class AddChatMemberStatusToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :chat_member_status, :string
  end
end
