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

def notice_request complaint
    res =  Send.mes(Text.complaint_request_to_moderator(complaint))
    mes_id = res['result']['message_id']
    $user.update(cur_message_id:mes_id)
    # puts mes_id
    to_start    
end

def already_requesting_complaint_6? complaint
    has_requesting_complain = Complaint.where(telegram_id:complaint.telegram_id).where(status:'request_to_moderator')
    return true if has_requesting_complain.any?
    false
  end
  
  def already_scammer_status_6? complaint
    userTo = User.find_by(telegram_id:complaint.telegram_id)
    return false if userTo.nil?
    return true if  userTo.status =~ /^scamer/
    return false
  end

def skip_details
    complaint = Complaint.find_by(id:$user.cur_complaint_id)
    
    is_scamer = already_scammer_status_6?(complaint)
    if is_scamer
         Send.mes(Text.notify_already_scammer_status)
         Send.mes(Text.greet, M::Reply.start)
         return
    end

    has_complaints = already_requesting_complaint_6?(complaint)
    if has_complaints
        Send.mes(Text.notify_already_has_requesting_complaint)
        Send.mes(Text.greet, M::Reply.start)
        return
   end



    notice_request complaint
    create_or_update_potential_user_scamer(complaint)
    system("bundle exec ruby #{UPLOAD_ON_FREEIMAGE} #{complaint.id} #{$user.id}") 
end

def handle_details
    complaint = Complaint.find_by(id:$user.cur_complaint_id)

    is_scamer = already_scammer_status_6?(complaint)
    if is_scamer
         Send.mes(Text.notify_already_scammer_status)
         Send.mes(Text.greet, M::Reply.start)
         return
    end

    has_complaints = already_requesting_complaint_6?(complaint)
    if has_complaints
        Send.mes(Text.notify_already_has_requesting_complaint)
        Send.mes(Text.greet, M::Reply.start)
        return
   end


    complaint.update(option_details:$mes.text)
    
    
    notice_request complaint
    create_or_update_potential_user_scamer(complaint)
    system("bundle exec ruby #{UPLOAD_ON_FREEIMAGE} #{complaint.id} #{$user.id}") 
end