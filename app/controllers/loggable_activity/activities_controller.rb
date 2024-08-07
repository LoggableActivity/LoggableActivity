# frozen_string_literal: true

module LoggableActivity
  # Controller for activities
  class ActivitiesController < ApplicationController
    def index
      @unique_actions = LoggableActivity::Activity.distinct.pluck(:action)
      @actor_display_names = LoggableActivity::Activity.distinct.pluck(:actor_display_name, :actor_id)

      @q = LoggableActivity::Activity.ransack(params[:q])
      @activities = @q.result.page(params[:page])
    end

    def search
      index
      render :index
    end
  end
end
