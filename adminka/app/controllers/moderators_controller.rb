class ModeratorsController < ApplicationController
  def index
    @moderators = Moderator.all.order(:created_at)
  end
end
