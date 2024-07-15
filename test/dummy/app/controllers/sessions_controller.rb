# frozen_string_literal: true

# Support for sessions
class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      user.log(:login, actor: user)
      redirect_to root_path, notice: 'Logged in successfully'
    else
      flash.now[:alert] = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    user = User.find(session[:user_id])
    session[:user_id] = nil
    user.log(:logout, actor: user)
    redirect_to root_path, notice: 'Logged out successfully'
  end
end
