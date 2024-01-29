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
#  managed_status_by         :string
#  state_aasm                :string
#  status                    :string
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

  attiribute :status, default: 'start_default'

  validates :managed_status_by, inclusion: { in: [
    nil,
    'moderator',
    'admin'
  ] }

  # 1 💤 Regular User = 💤 Мужик
  # 2 ⚠️ Suspect = ⚠️ Подозреваемый !!! Заменит текущий Scammer, выдается после принятие жалобы модератором
  # 3 🚫 Scammer/Ripper = 🚫 Кидок
  # 4 ✅ Oracle Verified =  ✅ Верифицированный Продавец
  # 5 🔱 Trusted = 🔱  Доверенный
  # 6 ♨️ DWC = ♨️ Проявите осторожность!
  # 7 ✅⚠️ Oracle Trial Verified = ✅⚠️ Верифицированный Продавец (испытательный срок)
  # 8 🌐 Federal Admin = 🌐 Админ Чатов

  validates :status, inclusion: { in: %w[
    start_default
    suspect
    scammer
    verified
    trusted
    dwc
    trial_verified
    federal_admin
  ] }
  # 'scammer:blocked_by_moderator',
end
