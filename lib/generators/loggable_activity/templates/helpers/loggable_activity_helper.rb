# frozen_string_literal: true

module LoggableActivityHelper
  include ApplicationHelper

  def render_activity(activity)
    render partial: template_path(activity), locals: { activity: }
  end

  def primary_type(activity)
    I18n.t("loggable.activity.models.#{activity.record_type}")
  end

  def relation_type(relation_attrs)
    I18n.t("loggable.activity.models.#{relation_attrs[:record_class]}")
  end

  def update_relation_class(update_attrs)
    I18n.t("loggable.activity.models.#{update_attrs[:record_class]}")
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
