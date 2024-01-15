# frozen_string_literal: true

module LoggableActivity
  module CurrentUser
    extend ActiveSupport::Concern

    included do
      before_action :set_current_user
      after_action :clear_current_user
    end

    private

    def set_current_user
      return unless current_user

      Thread.current[:current_user] = current_user
    end

    def clear_current_user
      Thread.current[:current_user] = nil
    end
  end
end
