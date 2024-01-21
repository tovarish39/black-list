# frozen_string_literal: true

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
class User < ApplicationRecord
  has_many :complaints, dependent: :destroy

  validates :status, inclusion: { in: [
    'not_scamer:default',

    'scamer:managed_by_admin',
    'scamer:managed_by_moderator',
    'scamer:blocked_by_moderator',

    'not_scamer:managed_by_admin',
    'not_scamer:managed_by_moderator',

    'verified:managed_by_admin',

    'trusted:managed_by_admin',
    'dwc:managed_by_admin'
  ] }
end
