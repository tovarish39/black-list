module ApplicationHelper
    def active? path
        path === request.path ? '__active' : ''
    end
end
