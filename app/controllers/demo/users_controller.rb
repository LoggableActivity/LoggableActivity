# frozen_string_literal: true

module Demo
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: %i[show edit update destroy]
    before_action :set_relations, only: %i[new edit]

    def index
      @users = User.all.order(:first_name)
    end

    def show
      @user.log(:show)
    end

    def new
      @user = User.new
    end

    def edit
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to demo_users_path, notice: 'User was successfully created.'
      else
        set_relations
        render :new
      end
    end

    def update
      if @user.update(user_params)
        redirect_to demo_users_path, notice: 'User was successfully updated.'
      else
        set_relations
        render :edit
      end
    end

    def destroy
      # Loggable::EncryptionKey.delete_key_for_owner(@user)
      @user.destroy
      redirect_to demo_users_url, notice: 'User was successfully destroyed.'
    end

    private

    def set_relations
      @addresses = Demo::Address.all
      @clubs= Demo::Club.all
    end

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
        :demo_address_id,
        :demo_club_id
      )
    end
  end
end
