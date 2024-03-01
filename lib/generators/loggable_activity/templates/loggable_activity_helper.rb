# frozen_string_literal: true

module LoggableActivityHelper
  include ApplicationHelper
  # include Rails.application.routes.url_helpers

  def render_activity(activity)
    render partial: template_path(activity), locals: { activity: }
  end

  def primary_type(activity)
    title = I18n.t("loggable.activity.models.#{activity.record_type}")
    if (path = activity.path)
      link_to title, send(path, activity.record_id.to_s)
    else
      title
    end
  end

  def relation_type(relation_attrs)
    title = I18n.t("loggable.activity.models.#{relation_attrs[:record_type]}")
    if (path = relation_attrs[:path])
      link_to title, send(path, relation_attrs[:record_id])
    else
      title
    end
  end

  def link_to_payload; end

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

  def activity_payload(activity)
    @activity_payload ||= build_payload(activity)
  end

  def activity_attrs(activity)
    @activity_attrs ||= activity_payload(activity).fetch(:activity, {})
  end

  def build_payload(activity)
    Loggable::JsonPayloadFactory.new(activity).build_payload
  end
end
