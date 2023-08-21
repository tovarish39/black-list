
class StateMachine
    aasm do
      state :request_to_userbot
      event :request_to_userbot_action, from: :request_to_userbot do

        transitions if: -> { mes_text?}, after: :handle_text_to_lookup,  to: :start
      end
    end
end




def handle_text_to_lookup group_chat_id = nil
    # из кнопки главного бота и из группы
    data =  if $mes.forward_from
                $mes.forward_from.id
            else
                $mes.text =~ /\/lookup/ ? $mes.text.split(' ')[1] : $mes.text
            end
    
    lookup_requests = Counter.first.lookup_requests_from_bots
    Counter.first.update(lookup_requests_from_bots: lookup_requests + 1 )

    spawn("bundle exec ruby #{$root_path}/request_on_python.rb #{data} #{$user.telegram_id} #{group_chat_id}")
end
