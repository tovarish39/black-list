module ApplicationHelper
    def active? path
        return '__active' if (request.path === '/') && (path === '/users')
        path === request.path ? '__active' : ''
    end

    def formatting_data user
        {lg:user[:lg], username:user[:username], telegram_id:user[:telegram_id]}.to_json
    end
end
