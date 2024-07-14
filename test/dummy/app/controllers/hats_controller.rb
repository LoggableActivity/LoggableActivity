# frozen_string_literal: true

class HatsController < ApplicationController
  before_action :set_hat, only: %i[edit update destroy]

  # PATCH/PUT /hats/1
  def update
    if @hat.update(hat_params)
      redirect_to @hat.user, notice: 'Hat was successfully updated.', status: :see_other
    else
      redirect_to @hat.user, notice: 'Hat was not updated.', status: :unprocessable_entity
      # render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /hats/1
  def destroy
    @hat.destroy
    redirect_to @hat.user, notice: 'Hat was successfully destroyed.'
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
