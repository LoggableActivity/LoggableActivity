# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include LoggableActivity::CurrentUser

  def authenticate_user!
    return if current_user

    redirect_to root_path, alert: 'You must be signed in to access this page.'
  end
end
