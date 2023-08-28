class User < ApplicationRecord
    has_many :complaints, dependent: :destroy

    validates :status, inclusion: {in: [
        'not_scamer:default',
        
        'scamer:managed_by_admin',
        'scamer:managed_by_moderator', 
        'scamer:blocked_by_moderator', 
        
        'not_scamer:managed_by_admin',
        'not_scamer:managed_by_moderator',
        
        'verified:managed_by_admin', 
        
        'trusted:managed_by_admin', 
        'dwc:managed_by_admin', 

        
      ]}
end
