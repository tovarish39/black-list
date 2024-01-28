# == Schema Information
#
# Table name: users
#
#  id                        :bigint           not null, primary key
#  chat_member_status        :string
#  date_when_became_a_scamer :datetime
#  first_name                :string
#  justification             :text
#  last_name                 :string
#  lg                        :string
#  managed_status_by         :string
#  state_aasm                :string
#  status                    :string           default("not_scamer:default")
#  username                  :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  complaint_id              :string
#  cur_complaint_id          :string
#  cur_message_id            :string
#  telegram_id               :string
#
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
