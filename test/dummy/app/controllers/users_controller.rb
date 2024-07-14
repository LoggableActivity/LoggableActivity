# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy create_hat]
  before_action :set_companies, only: %i[new edit]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    @user.log(:show)
    @hat = @user.hats.build
  end

  # GET /users/new
  def new
    @user = User.new
    @user.build_profile
  end

  # GET /users/1/edit
  def edit
    @user.build_profile if @user.profile.nil?
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_hat
    @hat = @user.hats.build(hat_params)
    if @hat.save
      redirect_to @user, notice: 'Hat was successfully created.'
    else
      render :show
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to users_path, notice: 'User was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy!
    redirect_to users_url, notice: 'User was successfully destroyed.', status: :see_other
  end

  private

  def set_companies
    @companies = Company.all
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params
      .require(:user)
      .permit(:first_name, :last_name, :email, :age, :user_type, :company_id,
              profile_attributes: %i[bio profile_picture_url location date_of_birth phone_number])
  end

  def hat_params
    params.require(:hat).permit(:color)
  end
end
