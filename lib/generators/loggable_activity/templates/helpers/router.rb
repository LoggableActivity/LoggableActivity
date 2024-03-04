# frozen_string_literal: true

require 'action_view'

module LoggableActivity
  module Router
    # include ApplicationHelper
    include LoggableActivity::RoutesHelper

    def primary_activity_text_or_link(activity)
      route = activity.primary_route
      text = text_for_link(route)
      return text if route.nil?
      return text if activity.record.nil?

      url = url_to_record(route, activity.record)
      return text unless url.present?

      link_to(text, url)
    end

    def payload_type_text_or_link(attrs)
      route = attrs[:route]
      return model_translation(attrs) if route.nil?

      record = find_record(attrs)
      return model_translation(attrs) if record.nil?

      text = text_for_link(route)

      url = url_to_record(route, record)
      return text if url.nil?

      link_to(text, url)
    end

    private

    def text_for_link(route)
      I18n.t("loggable.activity.routes.#{route}")
    end

    def model_translation(attrs)
      I18n.t("loggable.activity.models.#{attrs[:record_type]}")
    end

    def find_record(attrs)
      record_class = attrs[:record_type].constantize
      record_class.find(attrs[:record_id])
    end
  end
end
