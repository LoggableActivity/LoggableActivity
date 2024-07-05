# frozen_string_literal: true

module LoggableActivity
  # Controller for activities
  class ActivitiesController < ApplicationController
    def index
      @activities = LoggableActivity::Activity.order(created_at: :desc).page params[:page]
    end

    def show; end
  end
end
