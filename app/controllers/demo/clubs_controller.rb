# frozen_string_literal: true

module Demo
  class ClubsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_demo_club, only: %i[show edit update destroy]
    before_action :set_relations, only: %i[new edit]

    # GET /demo/clubs or /demo/clubs.json
    def index
      @demo_clubs = Demo::Club.all || []
    end

    # GET /demo/clubs/1 or /demo/clubs/1.json
    def show
      @demo_club.log(:show)
    end

    # GET /demo/clubs/new
    def new
      @demo_club = Demo::Club.new
    end

    # GET /demo/clubs/1/edit
    def edit; end

    # POST /demo/clubs or /demo/clubs.json
    def create
      @demo_club = Demo::Club.new(demo_club_params)

      respond_to do |format|
        if @demo_club.save
          format.html { redirect_to demo_clubs_path, notice: 'Club was successfully created.' }
          format.json { render :show, status: :created, location: @demo_club }
        else
          set_relations
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @demo_club.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /demo/clubs/1 or /demo/clubs/1.json
    def update
      respond_to do |format|
        if @demo_club.update(demo_club_params)
          format.html { redirect_to demo_clubs_path, notice: 'Club was successfully updated.' }
          format.json { render :show, status: :ok, location: @demo_club }
        else
          set_relations
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @demo_club.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /demo/clubs/1 or /demo/clubs/1.json
    def destroy
      @demo_club.destroy!

      respond_to do |format|
        format.html { redirect_to demo_clubs_url, notice: 'Club was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private

    def set_relations
      @addresses = Demo::Address.all || []
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_demo_club
      @demo_club = Demo::Club.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def demo_club_params
      params.require(:demo_club).permit(:name, :demo_address_id)
    end
  end
end
