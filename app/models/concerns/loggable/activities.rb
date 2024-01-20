# frozen_string_literal: true

module Loggable::Activities 
  extend ActiveSupport::Concern
  include Loggable::Attributes
  include Loggable::LogUpdate
  # include Loggable::JsonPayloadFactory

  included do
    config = Loggable::Configuration.for_class(name)
    self.loggable_attrs = config&.fetch('loggable_attrs', []) || []
    self.relations = config&.fetch('relations', []) || []
    self.auto_log = config&.fetch('auto_log', []) || []
    self.actor_display_name = config&.fetch('actor_display_name', nil)
    self.owner_display_name = config&.fetch('owner_display_name', 'email')

    after_create :log_create_activity
    after_update :log_update_activity
    before_destroy :log_destroy_activity
  end

  def log(activity, actor: nil, params: {})
    @activity = activity

  
    @actor = actor || Thread.current[:current_user]


    return if @actor.nil?

    @owner = self
    @params = params
    loggable_activity =
      case activity
      when :create, :show, :destroy
        log_activity(activity)
      when :update
        log_update(activity)
      else
        log_custom_activity(activity)
      end

    ap build_json_payload(loggable_activity) if loggable_activity
    
  end


  private

  def log_activity(activity)
    Loggable::Activity.create!(
      encoded_actor_display_name: actor_name,
      encoded_owner_display_name: owner_name,
      action: action_key,
      actor: @actor,
      owner: @owner,
      payloads: build_payloads
    )
  end

  def build_json_payload(loggable_activity)
    json_payload_factory = 
      Loggable::JsonPayloadFactory.new(loggable_activity)
    json_payload_factory
      .build_payload
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
    # Loggable::Activity.create!(
    #   encoded_actor_display_name: 'actor_name',
    #   encoded_owner_display_name: 'owner_name',
    #   action: action_key(activity),
    #   actor: Thread.current[:current_user],
    #   payloads:
    # )
  end

  def owner_name
    ap self.class.owner_display_name
    return self.class.name if self.class.owner_display_name.nil?

    display_name = send(self.class.owner_display_name.to_sym)
    Loggable::Encryption.encrypt(display_name, self)
  end

  def actor_name
    return self.class.name if self.class.actor_display_name.nil?

    display_name = @actor.send(self.class.actor_display_name.to_sym)
    Loggable::Encryption.encrypt(display_name, @actor)
  end

  def build_payloads
    payload_builder = Loggable::PayloadBuilder.new(@owner, @actor)
    payload_builder.build_payloads
  end

  def action_key
    @action_key ||= self.class.base_action + ".#{@activity}"
  end

  class_methods do
    attr_accessor :loggable_attrs, :relations, :auto_log, :owner_display_name, :actor_display_name

    def base_action
      name.downcase.gsub('::', '/')
    end
  end
end
