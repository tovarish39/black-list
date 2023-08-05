module ApplicationHelper
    def active? path
        return '__active' if (request.path === '/') && (path === '/users')
        path === request.path ? '__active' : ''
    end
end
