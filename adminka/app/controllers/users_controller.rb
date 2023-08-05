class UsersController < ApplicationController
  def index
    @users = User.all.order(:created_at)
    @languages = [
      {label:'ru', value:'ru', checked:true},
      {label:'en', value:'en', checked:false},
      {label:'es', value:'es', checked:false},
    ]

    @status_options = ['scamer', 'not_scamer', 'verified' ]
  end

  def update
    user = User.find(params[:id])
    formatted_new_status = "#{params[:new_status_value]}:managed_by_admin"
    user.update!(status: formatted_new_status)

    render json: { updated_status: user.status.split(":").first }
  end
end
