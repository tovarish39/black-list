# == Schema Information
#
# Table name: moderators
#
#  id                       :bigint           not null, primary key
#  access_amount            :integer          default(0)
#  block_amount             :integer          default(0)
#  chat_member_status       :string
#  decisions_per_day_amount :integer          default(0)
#  first_name               :string
#  last_name                :string
#  lg                       :string
#  reject_amount            :integer          default(0)
#  state_aasm               :string
#  status                   :string           default("active")
#  username                 :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  cur_complaint_id         :string
#  telegram_id              :string
#
require 'test_helper'

class ModeratorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
