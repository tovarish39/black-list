
class StateMachine
    aasm do
      state :request_to_userbot
      event :request_to_userbot_action, from: :request_to_userbot do

        transitions if: -> { mes_text?(Button.cancel) }, after: :to_start, to: :start
        
        transitions if: -> { mes_text? || is_user_shared? }, after: :handle_text_to_lookup, to: :request_to_userbot

      end
    end
end


def handle_text_to_lookup group_chat_id = nil
    # из кнопки главного бота и из группы
    data =  if is_user_shared?
                $mes.user_shared[:user_id].to_s
            elsif $mes.forward_from
                $mes.forward_from.id
            else
                $mes.text =~ /\/lookup/ ? $mes.text.split(' ')[1] : $mes.text
            end
    counter = Counter.first
    counter ||= Counter.create

    lookup_requests = counter.lookup_requests_from_bots
    counter.update(lookup_requests_from_bots: lookup_requests + 1 )
    request = "bundle exec ruby #{$root_path}/request_on_python.rb #{data} #{$user.telegram_id} #{group_chat_id}"
    puts request
    spawn(request)
end
