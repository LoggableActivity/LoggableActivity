# frozen_string_literal: true

module ActivityLogger
  extend ActiveSupport::Concern

  included do
    # Fetch configuration for the class including this module
    config = Loggable::Configuration.for_class(base_action)
    self.loggable_attrs = config&.fetch('loggable_attrs', []) || []
    self.obfuscate_attrs = config&.fetch('obfuscate_attrs', []) || []
    self.relations = config&.fetch('relations', []) || []
  end

  def log(activity, actor)
    build_payloads
    if activity == :update
      log_update(actor)
    else
      log_activity(activity, actor)
    end
  end

  private

  def log_activity(activity, actor)
    Loggable::Activity.create!(
      action: action(activity),
      actor:,
      payloads: [
        Loggable::Payload.new(
          attrs: { fo: 'bar' }.to_json
        )
      ]
    )
  end

  def build_payloads
    ap attrs_to_log(self.class.loggable_attrs, attributes)

    # ap self.class.relations
    # self.class.loggable_attrs.each do |attr|
    #   ap attr
    # end
  end

  def attrs_to_log(_loggable_attrs, attrs)
    attrs.slice(*self.class.loggable_attrs)
  end

  def action(activity)
    @action ||= self.class.base_action + ".#{activity}"
  end

  class_methods do
    attr_accessor :loggable_attrs, :obfuscate_attrs, :relations

    def base_action
      name.downcase.gsub('::', '.')
    end
  end
end
