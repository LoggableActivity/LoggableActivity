# frozen_string_literal: true

module LoggableActivity
  # Helper methods for activities
  module ActivitiesHelper
    require 'json'
    def activity_action(activity)
      I18n.t("loggable_activity.#{activity.action}")
    end

    def format_json_for_display(hash_data)
      JSON.pretty_generate(hash_data)
    rescue JSON::ParserError
      hash_data.to_s
    end

    def translated_actions(actions)
      actions.map do |action|
        [I18n.t("loggable_activity.#{action}"), action]
      end
    end
  end
end
