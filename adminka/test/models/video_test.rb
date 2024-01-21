# == Schema Information
#
# Table name: videos
#
#  id                      :bigint           not null, primary key
#  complaint_photos        :json
#  complaint_text          :json
#  input_username          :json
#  lookup_the_counterparty :json
#  option_details          :json
#  oracles_tips            :json
#  search_user             :json
#  start                   :json
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  compare_user_id         :json
#
require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
