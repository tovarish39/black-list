# == Schema Information
#
# Table name: configs
#
#  id                                 :bigint           not null, primary key
#  for_private_channel_video_file_ids :string           default([]), is an Array
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#
require "test_helper"

class ConfigTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
