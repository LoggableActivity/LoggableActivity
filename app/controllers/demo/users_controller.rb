# frozen_string_literal: true

module Demo
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: %i[show edit update destroy]
    before_action :ser_user_types, only: %i[new edit]
    before_action :set_relations, only: %i[new edit]

    def index
      @users = User.all.order(:first_name)
    end

    def show
      @user.log(:show)
      @loggable_activities = Loggable::Activity.where(actor: @user)
    end

    def new
      @user = User.new
    end

    def edit; end

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
      @user.destroy
      redirect_to demo_users_url, notice: 'User was successfully destroyed.'
    end

    private

    def set_relations
      @addresses = Demo::Address.all
      @clubs = Demo::Club.all
    end

    def set_user
      @user = User.find(params[:id])
    end

    def ser_user_types
      @roles = User.user_types.keys
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
        :demo_club_id,
        :user_type,
        demo_user_profile_attributes: %i[sex religion id]
      )
    end
  end
end
