class StateMachine
    include AASM
  
    aasm whiny_transitions: false
  
    aasm do
  
      # before_all_events   :log_before
      # after_all_events    :log_after
      # error_on_all_events :log_error
  

      state :test
    end


    # def income_message
    #   if mes_data?
    #     "data = #{$mes.data}"
    #   elsif mes_text?
    #     "text = #{$mes.text}"
    #   end
    # end
    # def log_before
    #   user = $user || $mod
    #   $logger.info("BEFORE ; user_id = #{user.id} ; from_state = #{aasm.current_state} ; '#{income_message}'")
    # end
  
    # def log_after
    #   user = $user || $mod
    #   $logger.info("AFTER  ; user_id = #{user.id} ; new_state  = #{aasm.current_state}")
    # end
  
    # def log_error(exception)
    #   user = $user || $mod
    #       fail
    #   $logger.error("ERR ; user_id = #{user.id} #{exception}")
    # end
  end