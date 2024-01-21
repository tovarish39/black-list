# == Schema Information
#
# Table name: complaints
#
#  id                          :bigint           not null, primary key
#  complaint_text              :text
#  explanation_by_moderator    :text
#  first_name                  :string
#  is_proofed_by_forwarted_mes :boolean
#  last_name                   :string
#  media_data                  :json
#  mes_id_published_in_channel :string
#  photo_file_ids              :string           is an Array
#  photo_urls_remote_tmp       :string           is an Array
#  photos_amount               :integer
#  photos_dir_path             :string
#  status                      :string           default("filling_by_user")
#  telegraph_link              :string
#  userbot_session             :string
#  username                    :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  handled_moderator_id        :string
#  private_channel_telegram_id :string
#  telegram_id                 :string
#  user_id                     :bigint           not null
#
# Indexes
#
#  index_complaints_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class ComplaintTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
