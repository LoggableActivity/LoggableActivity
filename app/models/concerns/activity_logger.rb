# frozen_string_literal: true

module ActivityLogger
  extend ActiveSupport::Concern
  include Loggable::Attributes
  include Loggable::LogUpdate

  included do
    config = Loggable::Configuration.for_class(name)
    self.loggable_attrs = config&.fetch('loggable_attrs', []) || []
    self.relations = config&.fetch('relations', []) || []
    self.auto_log = config&.fetch('auto_log', []) || []
    self.owner_name = config&.fetch('activity_name', nil)

    after_create :log_create_activity
    after_update :log_update_activity
    before_destroy :log_destroy_activity
  end

  def log(activity, actor: nil, owner: nil, params: {})
    @actor = actor || Thread.current[:current_user]

    return if @actor.nil?

    @owner = owner || self
    @params = params
    case activity
    when :create, :show, :destroy
      log_activity(activity)
    when :update
      log_update(activity)
    else
      log_custom_activity(activity)
    end
  end

  private

  def log_activity(activity)
    Loggable::Activity.create!(
      owner_name: owner_name,
      action: action(activity),
      actor: @actor,
      loggable: @owner,
      payloads: build_payloads
    )
  end

  def log_custom_activity(activity); end

  def log_create_activity
    log(:create) if self.class.auto_log.include?('create')
  end

  def log_destroy_activity
    log_destroy(:destroy) if self.class.auto_log.include?('destroy')
  end

  def log_destroy(activity)
    payloads = [
      Loggable::Payload.new(
        owner: @owner,
        name: self.class.name,
        encoded_attrs: { status: 'deleted' }
      )
    ]
    Loggable::EncryptionKey.delete_key_for_owner(@owner)
    Loggable::Activity.create!(
      owner_name: owner_name,
      action: action(activity),
      actor: Thread.current[:current_user],
      payloads:
    )
  end

  def owner_name
    return self.class.name if self.class.owner_name.nil?
    self.send(self.class.owner_name.to_sym)
  end

  def build_payloads
    payload_builder = Loggable::PayloadBuilder.new(@owner, @actor)
    payload_builder.build_payloads
  end

  def action(activity)
    @action ||= self.class.base_action + ".#{activity}"
  end

  class_methods do
    attr_accessor :loggable_attrs, :relations, :auto_log, :owner_name

    def base_action
      name.downcase.gsub('::', '/')
    end
  end
end
