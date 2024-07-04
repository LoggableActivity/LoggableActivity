# frozen_string_literal: true

module LoggableActivity
  class ActivitiesController < ApplicationController
    def index
      @activities = LoggableActivity::Activity.all
    end

    def show; end
  end
end
