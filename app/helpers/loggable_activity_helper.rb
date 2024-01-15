# frozen_string_literal: true

module LoggableActivityHelper
  include ApplicationHelper

  def render_activity(activity)
    render partial: template_path(activity), locals: { activity: }
  end

  private

  def action_template_path(activity)
    "loggable_activity/templates/#{activity.action.gsub('.', '/')}"
  end

  def template_path(activity)
    template_path = action_template_path(activity)
    if lookup_context.template_exists?(template_path, [], true)
      template_path
    else
      action = activity.action.split('.').last || 'default'
      "loggable_activity/templates/default/#{action}"
    end
  end
end
