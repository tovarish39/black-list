# == Schema Information
#
# Table name: configs
#
#  id                                 :bigint           not null, primary key
#  for_private_channel_video_file_ids :string           default([]), is an Array
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#
class Config < ApplicationRecord
end
