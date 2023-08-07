class AddChatMemberStatusToModerators < ActiveRecord::Migration[7.0]
  def change
    add_column :moderators, :chat_member_status, :string
  end
end
