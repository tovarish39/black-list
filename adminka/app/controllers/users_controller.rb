class UsersController < ApplicationController
  def index
    @users = User.all
    @languages = [
      {label:'ru', value:'ru', checked:true},
      {label:'en', value:'en', checked:false},
      {label:'es', value:'es', checked:false},
    ]
  end
end
