# frozen_string_literal: true

class ApplicationController < ActionController::Base # rubocop:disable Style/Documentation
  http_basic_authenticate_with name: 'admin', password: 'admin'
  before_action :set_links

  private

  def set_links
    @links = [
      { label: 'Users', path: '/users' },
      # { label: 'Scammers', path: '/scamers' },
      { label: 'Moderators', path: '/moderators' }
    ]
  end
end
