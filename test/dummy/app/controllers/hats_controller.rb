# frozen_string_literal: true

class HatsController < ApplicationController
  before_action :set_hat, only: %i[show edit update destroy]

  # GET /hats
  def index
    @hats = Hat.all
  end

  # GET /hats/1
  def show; end

  # GET /hats/new
  def new
    @hat = Hat.new
  end

  # GET /hats/1/edit
  def edit; end

  # POST /hats
  def create
    @hat = Hat.new(hat_params)

    if @hat.save
      redirect_to @hat, notice: 'Hat was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /hats/1
  def update
    if @hat.update(hat_params)
      redirect_to @hat, notice: 'Hat was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /hats/1
  def destroy
    @hat.destroy!
    redirect_to hats_url, notice: 'Hat was successfully destroyed.', status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_hat
    @hat = Hat.find(params[:id])
  end

  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def hat_params
    params.require(:hat).permit(:color, :user_id)
  end
end
