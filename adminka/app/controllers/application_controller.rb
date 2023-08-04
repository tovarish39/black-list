class ApplicationController < ActionController::Base
    before_action :get_links

    private
    def get_links
        @links = [
            {label:'Users', path:'/users'},
            {label:'Scamers', path:'/scamers'},
            {label:'Moderators', path:'/moderators'},
        ]
    end
end
