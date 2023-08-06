class Moderator < ApplicationRecord
    validates :status, inclusion: {in: [
        'active', 'inactive'
        ]}
end
