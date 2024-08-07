# frozen_string_literal: true

module LoggableActivity
  # Controller for activities
  class ActivitiesController < ApplicationController
    def index
      @unique_actions = LoggableActivity::Metadata.distinct.pluck(:action)
      @actor_names = LoggableActivity::Metadata.distinct.pluck(:actor_display_name, :actor_id)

      @q = LoggableActivity::Metadata.ransack(params[:q])
      results = @q.result

      record_ids = results.map(&:record_id)
      record_types = results.map(&:record_type)

      @activities = 
        LoggableActivity::Activity.where(record_id: record_ids)
                                  .where(record_type: record_types)
                                  .page(params[:page])
    end

    def search
      index
      render :index
    end

    # def activity_params
    #   params.require(:activity).permit(:action, :actor_id, :actor_type, :actor_display_name, :record_id, :record_type, :record_display_name)
    # end
  end
end
