# frozen_string_literal: true

module Demo
  class ActivityLogsController < ApplicationController
    before_action :authenticate_user!

    def show
      @loggable_activity = Loggable::Activity.find(params[:id])
    end

    def index
      @loggable_activities = Loggable::Activity.latest(50)
    end

    def destroy
      @loggable_activity = Loggable::Activity.find(params[:id])
      @loggable_activity.destroy!
      redirect_to demo_activity_logs_path, notice: 'Activity was successfully destroyed.'
    end
  end
end
