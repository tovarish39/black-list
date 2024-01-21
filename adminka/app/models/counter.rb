# == Schema Information
#
# Table name: counters
#
#  id                        :bigint           not null, primary key
#  lookup_requests_from_bots :integer          default(0)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
class Counter < ApplicationRecord
end
