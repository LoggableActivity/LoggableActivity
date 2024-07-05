# frozen_string_literal: true

module LoggableActivity
  # Helper methods for activities
  module ActivitiesHelper
    def activity_action(activity)
      I18n.t("loggable_activity.#{activity.action}")
    end
  end
end
