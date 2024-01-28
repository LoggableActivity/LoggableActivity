# frozen_string_literal: true

module Demo
  class AddressesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_address, only: %i[show edit update destroy]

    # GET /demo/addresses or /demo/addresses.json
    def index
      @addresses = Demo::Address.all
    end

    # GET /demo/addresses/1 or /demo/addresses/1.json
    def show
      @address.log(:show)
    end

    # GET /demo/addresses/new
    def new
      @address = Demo::Address.new
    end

    # GET /demo/addresses/1/edit
    def edit; end

    # POST /demo/addresses or /demo/addresses.json
    def create
      @address = Demo::Address.new(address_params)

      respond_to do |format|
        if @address.save
          # @address.log(:create, current_user)
          format.html { redirect_to demo_address_url(@address), notice: 'Address was successfully created.' }
          format.json { render :show, status: :created, location: @address }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @address.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /demo/addresses/1 or /demo/addresses/1.json
    def update
      respond_to do |format|
        if @address.update(address_params)
          format.html { redirect_to demo_addresses_path, notice: 'Address was successfully updated.' }
          format.json { render :show, status: :ok, location: @address }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @address.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @address.destroy!

      respond_to do |format|
        format.html { redirect_to demo_addresses_url, notice: 'Address was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Demo::Address.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def address_params
      params.require(:demo_address).permit(:street, :city, :country, :postal_code)
    end
  end
end
