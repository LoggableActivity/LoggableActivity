# frozen_string_literal: true

module Demo
  class ActivityLogsController < ApplicationController
    def show
      @loggable_activity = Loggable::Activity.find(params[:id])
    end

    def index
      @loggable_activities = Loggable::Activity.all.order(created_at: :desc)
    end

    def destroy
      @loggable_activity = Loggable::Activity.find(params[:id])
      @loggable_activity.destroy!
      redirect_to demo_activity_logs_path, notice: 'Activity was successfully destroyed.'
    end
  end
end
