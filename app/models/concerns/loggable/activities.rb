# frozen_string_literal: true

module Loggable
  module Activities
    extend ActiveSupport::Concern
    include Loggable::Attributes
    include Loggable::PayloadsBuilder
    include Loggable::UpdatePayloadsBuilder

    included do
      config = Loggable::Configuration.for_class(name)
      raise "Loggable::Configuration not found for #{name}, Please add it to 'config/loggable_activity.yaml'" if config.nil?
      self.loggable_attrs = config&.fetch('loggable_attrs', []) || []
      self.relations = config&.fetch('relations', []) || []
      self.auto_log = config&.fetch('auto_log', []) || []
      self.actor_display_name = config&.fetch('actor_display_name', nil)
      self.record_display_name = config&.fetch('record_display_name', nil)

      after_create :log_create_activity
      after_update :log_update_activity
      before_destroy :log_destroy_activity
    end

    def log(activity, actor: nil, params: {})
      @activity = activity
      @actor = actor || Thread.current[:current_user]

      return if @actor.nil?

      @record = self
      @params = params
      @payloads = []
      
      case activity
      when :create, :show, :destroy
        log_activity
      when :update
        log_update
      else
        log_custom_activity(activity)
      end
    end

    private

    # TODO: DRY
    def log_activity
      Loggable::Activity.create!(
        encoded_actor_display_name: encoded_actor_name,
        encoded_record_display_name: encoded_record_name,
        action: action_key,
        actor: @actor,
        record: @record,
        payloads: build_payloads
      )
    end

    def log_update_activity
      log(:update) if self.class.auto_log.include?('update')
    end

    def log_update
      Loggable::Activity.create!(
        encoded_actor_display_name: encoded_actor_name,
        encoded_record_display_name: encoded_record_name,
        action: action_key,
        actor: @actor,
        record: @record,
        payloads: build_update_payloads
      )
    end

    def log_custom_activity(activity); end

    def log_create_activity
      log(:create) if self.class.auto_log.include?('create')
    end

    def log_destroy_activity
      Loggable::EncryptionKey.delete_key_for_record(self)
      log_destroy(:destroy) if self.class.auto_log.include?('destroy')
    end

    def log_destroy(_activity)
      
    end

    def encoded_record_name
      return self.class.name if self.class.record_display_name.nil?

      display_name = send(self.class.record_display_name.to_sym)
      # key = Loggable::EncryptionKey.for_record(self)
      Loggable::Encryption.encrypt(display_name, primary_encryption_key)
    end

    def encoded_actor_name
      return self.class.name if self.class.actor_display_name.nil?
      display_name = @actor.send(self.class.actor_display_name.to_sym)
      Loggable::Encryption.encrypt(display_name, actor_encryption_key)
    end

    def action_key
      @action_key ||= self.class.base_action + ".#{@activity}"
    end

    def primary_encryption_key
      Loggable::EncryptionKey.for_record(self) 
    end

    def actor_encryption_key
      Loggable::EncryptionKey.for_record(@actor)
    end

    class_methods do
      attr_accessor :loggable_attrs, :relations, :auto_log, :record_display_name, :actor_display_name

      def base_action
        name.downcase.gsub('::', '/')
      end
    end
  end
end
