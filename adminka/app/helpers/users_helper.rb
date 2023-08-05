module UsersHelper
    def default_options statuses,  user_status
        new_order_statuses = [user_status]
        statuses.each do |status|
            new_order_statuses.push(status) if user_status.split(":").first != status
        end
        new_order_statuses.map {|option| option.split(":").first}
    end
end
