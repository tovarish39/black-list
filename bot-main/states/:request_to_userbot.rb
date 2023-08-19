
class StateMachine
    aasm do
      state :request_to_userbot
      event :request_to_userbot_action, from: :request_to_userbot do

        transitions if: -> { mes_text?}, after: :handle_text,  to: :start
      end
    end
end




def handle_text
    data =  if $mes.forward_from
                $mes.forward_from.id
            else
                $mes.text
            end

    system("bundle exec ruby #{$root_path}/request_on_python.rb #{data} #{$user.telegram_id}")
end
