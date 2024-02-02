# frozen_string_literal: true

module Demo
  class JournalsController < ApplicationController
    before_action :set_demo_journal, only: %i[show edit update destroy]
    before_action :set_patients, only: %i[new create]
    before_action :set_doctors, only: %i[new edit update create]

    # GET /demo/journals or /demo/journals.json
    def index
      @demo_journals = Demo::Journal.all
    end

    # GET /demo/journals/1 or /demo/journals/1.json
    def show
      @demo_journal.log(:show)
    end

    # GET /demo/journals/new
    def new
      @demo_journal = Demo::Journal.new
    end

    # GET /demo/journals/1/edit
    def edit; end

    # POST /demo/journals or /demo/journals.json
    def create
      @demo_journal = Demo::Journal.new(demo_journal_params)

      respond_to do |format|
        if @demo_journal.save
          format.html { redirect_to demo_journals_path, notice: 'Journal was successfully created.' }
          format.json { render :show, status: :created, location: @demo_journal }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @demo_journal.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /demo/journals/1 or /demo/journals/1.json
    def update
      respond_to do |format|
        if @demo_journal.update(demo_journal_params)
          format.html { redirect_to demo_journals_path, notice: 'Journal was successfully updated.' }
          format.json { render :show, status: :ok, location: @demo_journal }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @demo_journal.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /demo/journals/1 or /demo/journals/1.json
    def destroy
      @demo_journal.destroy!

      respond_to do |format|
        format.html { redirect_to demo_journals_url, notice: 'Journal was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_demo_journal
      @demo_journal = Demo::Journal.find(params[:id])
    end

    def set_patients
      @patients = User.where(user_type: 'Patient')
    end

    def set_doctors
      @doctors = User.where(user_type: 'Doctor')
    end

    # Only allow a list of trusted parameters through.
    def demo_journal_params
      params.require(:demo_journal).permit(:patient_id, :doctor_id, :title, :body, :state)
    end
  end
end
