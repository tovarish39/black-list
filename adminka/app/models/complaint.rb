class Complaint < ApplicationRecord
  belongs_to :user

  validates :status, inclusion: {in: [
    'filling_by_user',
    'request_to_moderator', 
    'accepted_complaint',
    'rejected_complaint',
  ]}
end
