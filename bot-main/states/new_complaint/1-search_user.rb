# frozen_string_literal: true

class StateMachine
  class_eval do
    include AASM
    aasm do
      state :search_user

      event :search_user_action, from: :search_user do
        transitions if: -> { mes_text?(Button.cancel) }, after: :to_start, to: :start

        transitions if: -> { (is_user_shared? || mes_text?) && already_scammer_status? },       after: :notify_already_scammer_status, to: :search_user
        transitions if: -> { (is_user_shared? || mes_text?) && already_requesting_complaint? }, after: :notify_already_has_requesting_complaint, to: :search_user
        transitions if: -> { is_user_shared? || mes_text? }, after: :to_verify_user_info, to: :verify_user_info
      end
    end
  end
end


def already_requesting_complaint?
  is_username_input = mes_text? && !($mes.text =~ /^-?\d+$/)
  # userTo = if  is_username_input
  #   User.find_by(username:$mes.text.sub('@',''))
  #  else 
  #   userTo_telegram_id = get_userTo_telegram_id()
  #   User.find_by(telegram_id:userTo_telegram_id)
  #  end

  complaints = if is_username_input
      Complaint.where(username:$mes.text.sub('@',''))
    else
      Complaint.where(telegram_id:get_userTo_telegram_id())
    end

  has_requesting_complain = complaints.where(status:'request_to_moderator')



  return true if has_requesting_complain.any?
  false
end

def already_scammer_status?
  is_username_input = mes_text? && !($mes.text =~ /^-?\d+$/)
  
  
  
  userTo = if  is_username_input
            User.find_by(username:$mes.text.sub('@',''))
           else 
            userTo_telegram_id = get_userTo_telegram_id()
            User.find_by(telegram_id:userTo_telegram_id)
           end


  return false if userTo.nil?

  return false if  !(userTo.status =~ /^scamer/)

  return true
end

def notify_already_scammer_status
  Send.mes(Text.notify_already_scammer_status, M::Reply.search_user)
end

def notify_already_has_requesting_complaint
  Send.mes(Text.notify_already_has_requesting_complaint, M::Reply.search_user)
end

def is_user_shared?
  $mes.user_shared.present? ? true : false
end

def replace_invalid_characters(input_string)
  invalid_characters = ['/', '\\', '?', '*', ':', '"', '<', '>', '|', "\0", "\t", "\n", "\r"]
  replaced_string = input_string.gsub(/[#{Regexp.escape(invalid_characters.join)}]/, '_')
  replaced_string
end

def is_telegram_id text
  /^-?\d+$/ =~ text
end

def get_userTo_telegram_id
  userTo_telegram_id =  if    is_user_shared?
                          $mes.user_shared[:user_id].to_s
                        elsif mes_text? && is_telegram_id($mes.text)
                          # при вводе текста меняем "/" чтоб папки не ломало
                          replace_invalid_characters($mes.text)
                        else  
                           nil
                        end
  userTo_telegram_id   
end

def to_verify_user_info
  userTo_telegram_id = get_userTo_telegram_id()

  filling_complait = if userTo_telegram_id
                        $user.complaints.find_by(
                          status: 'filling_by_user',
                          telegram_id: userTo_telegram_id
                        )
                     else # username
                      $user.complaints.find_by(
                        status: 'filling_by_user',
                        username: $mes.text.sub('@','')
                      )
                     end


  #  puts filling_complait.inspect

  complaint = if filling_complait.present?
                  filling_complait
              elsif userTo_telegram_id
               Complaint.create(
                telegram_id: userTo_telegram_id,
                user_id: $user.id,
                status: 'filling_by_user'
              )
              else # username
                Complaint.create(
                  username: $mes.text.sub('@',''),
                  user_id: $user.id,
                  status: 'filling_by_user'
                ) 
              end
  $user.update(cur_complaint_id: complaint.id)
# puts complaint.inspect
  if userTo_telegram_id
    begin
      data = GetChat.info(userTo_telegram_id)['result']
      complaint.username   = data['username']
      complaint.first_name = data['first_name']
      complaint.last_name  = data['last_name']
    rescue StandardError
      usetTo = User.find_by(telegram_id:userTo_telegram_id)
      if usetTo.present?
        complaint.username   = usetTo.username
        complaint.first_name = usetTo.first_name
        complaint.last_name  = usetTo.last_name
      end
    end
  end
  complaint.save

  Send.mes(Text.user_info(complaint), M::Reply.user_info)
end
