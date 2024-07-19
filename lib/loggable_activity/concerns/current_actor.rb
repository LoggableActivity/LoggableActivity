# frozen_string_literal: true

module LoggableActivity
  # Stores current user in a thread variable so is can be accessed from the LoggableActivity::Hook model
  module CurrentActor
    extend ActiveSupport::Concern

    included do
      before_action :set_current_actor
      after_action :clear_current_actor
    end

    private

    def set_current_actor
      return unless current_user

      Thread.current[:current_actor] = current_user
    end

    def clear_current_actor
      Thread.current[:current_actor] = nil
    end
  end
end
