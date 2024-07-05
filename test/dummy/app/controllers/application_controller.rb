# frozen_string_literal: true

# Application controller
class ApplicationController < ActionController::Base
  include ::LoggableActivity::CurrentUser
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
