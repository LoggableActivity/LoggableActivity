# frozen_string_literal: true

require 'active_support/concern'

# This is the main module for loggable.
# When included to a model, it provides the features for creating the activities.
require 'loggable_activity/payloads_builder'
require 'loggable_activity/update_payloads_builder'

module LoggableActivity
  # This module provides hooks for creating activities when included in a model.
  module Hooks
    extend ActiveSupport::Concern
    include LoggableActivity::PayloadsBuilder
    include LoggableActivity::UpdatePayloadsBuilder

    # The included hook sets up configuration and callback hooks for the model.
    included do
      config = LoggableActivity::Configuration.for_class(name)

      raise "Loggable::Configuration not found for #{name}, Please add it to 'config/loggable_activity.yaml'" if config.nil?

      # Initializes attributes based on configuration.
      self.loggable_attrs = config&.fetch('loggable_attrs', []) || []
      self.relations = config&.fetch('relations', []) || []
      self.auto_log = config&.fetch('auto_log', []) || []
      self.actor_display_name = config&.fetch('actor_display_name', nil)
      self.record_display_name = config&.fetch('record_display_name', nil)
      self.route = config&.fetch('route', nil)

      after_create :log_create_activity
      after_update :log_update_activity
      before_destroy :log_destroy_activity
    end

    # Logs an activity with the specified action, actor, and params.
    #
    #   @param action [Symbol] The action to log (:create, :update, :destroy, or custom).
    #   @param actor [Object] The actor performing the action.
    #   @param params [Hash] Additional parameters for the activity.
    def log(action, actor: nil, params: {})
      @action = action
      @actor = actor || Thread.current[:current_user]
      # LoggableActivity::EncryptionKey.for_record(self)

      return if @actor.nil?

      @record = self
      @params = params
      @payloads = []

      case action
      when :create, :show
        log_activity
      when :destroy
        log_destroy
      when :update
        log_update
      else
        log_custom_activity(action)
      end
    end

    private

    # Logs an activity for the current action.
    def log_activity
      create_activity(build_payloads)
    end

    # Logs an activity for the update action.
    def log_update
      create_activity(build_update_payloads)
    end

    # Logs an activity for the destroy action.
    def log_destroy
      create_activity(build_destroy_payload)
    end

    # Creates an activity with the specified payloads.
    def create_activity(payloads)
      return if nothing_to_log?(payloads)

      LoggableActivity::Activity.create!(
        encrypted_actor_display_name: encrypted_actor_name,
        encrypted_record_display_name: encrypted_record_name,
        action: action_key,
        actor: @actor,
        record: @record,
        payloads:
      )
    end

    # Returns true if there are no payloads to log.
    def nothing_to_log?(payloads)
      payloads.empty?
    end

    # Logs a custom activity.
    def log_custom_activity(activity); end

    # Logs an update activity automatically if configured.
    def log_update_activity
      log(:update) if self.class.auto_log.include?('update')
    end

    # Logs a create activity automatically if configured.
    def log_create_activity
      log(:create) if self.class.auto_log.include?('create')
    end

    # Logs a destroy activity automatically if configured.
    def log_destroy_activity
      LoggableActivity::EncryptionKey.for_record(self)&.mark_as_deleted
      log(:destroy) if self.class.auto_log.include?('destroy')
    end

    # Returns the encrypted name of the actor.
    def encrypted_actor_name
      actor_display_name = @actor.send(actor_display_name_field)
      LoggableActivity::Encryption.encrypt(actor_display_name, actor_encryption_key)
    end

    # Returns the encrypted name of the record.
    def encrypted_record_name
      display_name =
        if self.class.record_display_name.nil?
          "#{self.class.name} id: #{id}"
        else
          send(self.class.record_display_name.to_sym)
        end
      LoggableActivity::Encryption.encrypt(display_name, primary_encryption_key)
    end

    # Returns the action key for the current action.
    def action_key
      @action_key ||= self.class.base_action + ".#{@action}"
    end

    # Returns the primary encryption key for the activity
    def primary_encryption_key
      @primary_encryption_key ||=
        LoggableActivity::EncryptionKey.for_record(self)&.key
    end

    # Returns true if the primary encryption key is deleted.
    def primary_encryption_key_deleted?
      primary_encryption_key.nil?
    end

    # Returns the encryption key for the actor.
    def actor_encryption_key
      LoggableActivity::EncryptionKey.for_record(@actor)&.key
    end

    # Returns the display name of the actor.
    def actor_display_name_field
      Rails.application.config.loggable_activity.actor_display_name || "id: #{@actor.id}, class: #{@actor.class.name}"
    end

    # Returns the model name of the current user.
    def current_user_model?
      Rails.application.config.loggable_activity.current_user_model_name == self.class.name
    end

    class_methods do
      attr_accessor :loggable_attrs, :relations, :auto_log, :actor_display_name, :record_display_name, :route

      # Convert the model name and name space in to 'base_action'.
      def base_action
        name.downcase.gsub('::', '/')
      end
    end
  end
end
