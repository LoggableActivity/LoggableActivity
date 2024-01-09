# frozen_string_literal: true

module Demo
  class UsersController < ApplicationController
    before_action :set_user, only: %i[show edit update destroy]

    def index
      @users = User.all
    end

    def show
      @user.log(:show, current_user, @user)
    end

    def new
      @user = User.new
      @addresses = Demo::Address.all
    end

    def edit
      @addresses = Demo::Address.all
    end

    def create
      @user = User.new(user_params)
      if @user.save
        @user.log(:create, current_user)
        redirect_to demo_users_path, notice: 'User was successfully created.'
      else
        render :new
      end
    end

    def update
      if @user.update(user_params)
        redirect_to demo_users_path, notice: 'User was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      Loggable::EncryptionKey.delete_key_for_owner(@user)
      @user.destroy
      redirect_to demo_users_url, notice: 'User was successfully destroyed.'
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :email,
        :password,
        :password_confirmation,
        :first_name,
        :last_name,
        :age,
        :bio,
        :demo_address_id
      )
    end
  end
end
