# frozen_string_literal: true

require 'active_support/concern'

module LoggableActivity
  # This module provides hooks for creating activities when included in a model.
  # When included to a model, it provides the features for logging events regarding to the model.
  # For this to work you have to update the configuration file 'config/loggable_activity.yaml

  # When included to a model, it provides the features for logging events regarding to the model.
  # For this to work you have to update the configuration file 'config/loggable_activity.yaml
  module Hooks
    extend ActiveSupport::Concern
    # The disable_hooks attribute is used to disable hooks when a model is created or updated by a parent model.
    attr_accessor :disable_hooks

    # The included hook sets up configuration and callback hooks for the model.
    included do
      config = ::LoggableActivity::Configuration.for_class(name)

      if config.nil?
        raise LoggableActivity::Error, "Configuration not found for #{name}, Please add it to 'config/loggable_activity.yaml"
      end

      # Initializes attributes based on configuration.
      self.loggable_attrs = config&.fetch('loggable_attrs', []) || []
      self.relations = config&.fetch('relations', []) || []
      self.auto_log = config&.fetch('auto_log', []) || []
      self.fetch_record_name_from = config&.fetch('fetch_record_name_from', nil)
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
      return nil if @actor.nil?

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
      return nil if nothing_to_log?(payloads)

      ::LoggableActivity::Activity.create!(
        encrypted_actor_name:,
        action: action_key,
        actor: @actor,
        record: self,
        payloads:
      )
    end

    # Builds update payloads for the current action.
    def build_update_payloads
      ::LoggableActivity::Services::UpdatePayloadsBuilder
        .new(self, @payloads).build
    end

    # Builds payloads for the current action.
    def build_payloads
      ::LoggableActivity::Services::PayloadsBuilder
        .new(self, @payloads).build
    end

    # Builds destroy payloads for the current action.
    def build_destroy_payload
      ::LoggableActivity::Services::DestroyPayloadsBuilder
        .new(self, @payloads).build
    end

    # Returns true if there are no payloads to log.
    def nothing_to_log?(_payloads)
      @payloads.empty?
    end

    # Logs a custom activity.
    def log_custom_activity(activity); end

    # Logs an update activity automatically if configured.
    def log_update_activity
      return unless hooks_enabled?

      log(:update) if self.class.auto_log.include?('update')
    end

    # Hooks can disabled when a model is created or updated
    # by a parrent model.
    def hooks_enabled?
      enabled = disable_hooks.nil? || disable_hooks == false
      self.disable_hooks = false
      enabled
    end

    # Logs a create activity automatically if configured.
    def log_create_activity
      return unless hooks_enabled?

      log(:create) if self.class.auto_log.include?('create')
    end

    # Logs a destroy activity automatically if configured.
    def log_destroy_activity
      mark_encryption_keys_as_deleted
      return unless hooks_enabled?

      log(:destroy) if self.class.auto_log.include?('destroy')
    end

    # Fullfill the needs of the data owners.
    # Mostly this will be performend a few one, from 1 to 5.
    # Enumeration for different payload relation types
    def mark_encryption_keys_as_deleted
      ::LoggableActivity::EncryptionKey.for_record(self)&.mark_as_deleted!
      # data_owners = ::LoggableActivity::DataOwner.where(record: self)
      ::LoggableActivity::DataOwner
        .where(record: self)
        .each(&:mark_as_deleted!)
    end

    # Returns the encrypted name of the actor.
    def encrypted_actor_name
      name = @actor.send(fetch_current_user_name_from)
      ::LoggableActivity::Encryption.encrypt(name, actor_secret_key)
    end

    # Reads the field to feetch the record name from.
    def fetch_current_user_name_from
      ::LoggableActivity::Configuration.fetch_current_user_name_from
    end

    # Returns the action key for the current action.
    def action_key
      self.class.base_action + ".#{@action}"
    end

    # Returns the primary encryption key for the activity
    def primary_encryption_key
      encryption_key_for_record
    end

    # Returns the encryption key for the record.
    def encryption_key_for_record(record = @record)
      ::LoggableActivity::EncryptionKey.for_record(record)
    end

    # Returns the encryption key for the actor.
    def actor_secret_key
      encryption_key_for_record(@actor)&.secret_key
    end

    # Returns the display name of the actor.
    def actor__name_field
      Rails.application.config.loggable_activity.actor_display_name || "id: #{@actor.id}, class: #{@actor.class.name}"
    end

    # Returns the model name of the current user.
    def current_user_model?
      Rails.application.config.loggable_activity.current_user_model_name == self.class.name
    end

    class_methods do
      # The loggable_attrs attribute is used read the configuration for the model that included LoggableActivity::Hooks.
      attr_accessor :loggable_attrs, :relations, :auto_log, :fetch_record_name_from, :route

      # Convert the model name and name space in to 'base_action'.
      def base_action
        name.downcase.gsub('::', '/')
      end
    end
  end
end
