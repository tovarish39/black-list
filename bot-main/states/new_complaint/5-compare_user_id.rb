class StateMachine
    class_eval do
      include AASM
      aasm do
        state :compare_user_id
  
        event :compare_user_id_action, from: :compare_user_id do
          transitions if: -> { mes_text?(Button.cancel) }, after: :to_start    , to: :start
          transitions if: -> { mes_text?(Button.skip) }  , after: :skip_proof  , to: :option_details

          transitions if: -> { forwarted? &&  match? }   , after: :handle_proof, to: :option_details
          transitions if: -> { forwarted? && !match? }   , after: :nothing     , to: :compare_user_id

        end
      end
    end
end
  
def forwarted?
    $mes.forward_from.present? 
end

def match?
    complaint = Complaint.find_by(id:$user.cur_complaint_id)
    forwarded_telegram_id = $mes.forward_from.id.to_s
    writed_telegram_id = complaint.telegram_id
    forwarded_telegram_id == writed_telegram_id
end

def nothing
end


def create_or_update_potential_user_scamer complaint
    potential_scamer = User.find_by(telegram_id:complaint.telegram_id)

    if potential_scamer.nil?
        User.create(
            telegram_id:complaint.telegram_id,
            username:   complaint.username,
            first_name: complaint.first_name,
            last_name:  complaint.last_name
        ) 
    else
        potential_scamer.username   = complaint.username   if complaint.username.present?
        potential_scamer.first_name = complaint.first_name if complaint.first_name.present?
        potential_scamer.last_name  = complaint.last_name  if complaint.last_name.present?
        potential_scamer.save
    end
end




def handle_proof
    complaint = Complaint.find_by(id:$user.cur_complaint_id)
    complaint.update(is_proofed_by_forwarted_mes:true)
    
    Send.mes(Text.option_details)
end

def skip_proof
    complaint = Complaint.find_by(id:$user.cur_complaint_id)
    complaint.update(photo_urls_remote_tmp:[]) # чтоб не добавлялись фото, при неудачной загрузке не телеграф

    Send.mes(Text.option_details)
end