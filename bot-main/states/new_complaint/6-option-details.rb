class StateMachine
    class_eval do
      include AASM
      aasm do
        state :option_details
  
        event :option_details_action, from: :option_details do
            transitions if: -> { mes_text?(Button.cancel) }, after: :to_start       , to: :start
            transitions if: -> { mes_text?(Button.skip) }  , after: :skip_details   , to: :start
              
            transitions if: -> { mes_text?() }             , after: :handle_details , to: :start

        end
      end
    end
end



def notice_request complaint
    res =  Send.mes(Text.complaint_request_to_moderator(complaint))
    mes_id = res['result']['message_id']
    $user.update(cur_message_id:mes_id)
    # puts mes_id
    to_start    
end


def skip_details
    complaint = Complaint.find_by(id:$user.cur_complaint_id)

    notice_request complaint
    system("bundle exec ruby #{UPLOAD_ON_FREEIMAGE} #{complaint.id} #{$user.id}") 
    create_or_update_potential_user_scamer(complaint)
end

def handle_details
    complaint = Complaint.find_by(id:$user.cur_complaint_id)
    complaint.update(option_details:$mes.text)
    
    
    notice_request complaint
    system("bundle exec ruby #{UPLOAD_ON_FREEIMAGE} #{complaint.id} #{$user.id}") 
    create_or_update_potential_user_scamer(complaint)
end