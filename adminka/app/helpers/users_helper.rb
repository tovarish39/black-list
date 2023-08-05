module UsersHelper
    def default_options statuses,  user_status
        new_order_statuses = [user_status]
        statuses.each do |status|
            new_order_statuses.push(status) if user_status.split(":").first != status
        end
        new_order_statuses.map {|option| option.split(":").first}
    end
    def formatting_data user
        {lg:user[:lg], username:user[:username], telegram_id:user[:telegram_id]}.to_json
    end
end
