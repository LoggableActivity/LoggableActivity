# frozen_string_literal: true

require 'json-schema'
require 'json'

module LoggableActivity
  # This class is used to load the configuration file located at config/loggable_activity.yml
  class ConfigurationError < StandardError
    def initialize(msg = '')
      # https://api.loggable_activity.com/msg
      puts '---------------- LOGGABLE ACTIVITY -----------------'
      puts msg
      puts '----------------------------------------------------'
      super(msg)
    end
  end

  # This class is used to load the configuration file located at config/loggable_activity.yml
  # When the LoggableActivity::Hook is included in a model
  # it takes the model's name and find the configuration for that model in the configuration file.
  class Configuration
    # Loads the configuration file
    def self.load_config_file(config_file_path)
      @config_data = YAML.load_file(config_file_path)
      validate_config_file
    rescue Errno::ENOENT
      raise ConfigurationError, 'config/loggable_activity.yaml not found'
    end

    # Loads the schema file for the configuration file
    def self.load_schema
      schema_path = File.join(__dir__, '..', 'schemas', 'config_schema.json')
      JSON.parse(File.read(schema_path))
    end

    # Validates the configuration file againss the schema
    def self.validate_config_file
      schema = load_schema
      errors = JSON::Validator.fully_validate(schema, @config_data)
      return unless errors.any?

      raise ConfigurationError,
            "config/loggable_activity.yaml is invalid: #{errors.join(', ')}"
    end

    # Returns true if the configuration file has been loaded
    def self.loaded?
      !@config_data.nil?
    end

    # Returns the configuration data
    class << self
      # @return [Hash]
      attr_reader :config_data
    end

    # Returns the configuration data for the given class
    #
    # Example:
    #   ::LoggableActivity::Configuration.for_class('User')
    # Returns:
    #   {
    #     "fetch_record_name_from": "full_name",
    #     "loggable_attrs": [
    #       "first_name",
    #       "last_name",
    #     ],
    #     "auto_log": [
    #       "create",
    #       "update",
    #       "destroy"
    #     ],
    #   ....
    #   }
    def self.for_class(class_name)
      @config_data[class_name]
    end

    # Returns the name of the field or method to use for the actor's display name.
    def self.fetch_current_user_name_from
      @config_data['fetch_current_user_name_from']
    end

    # Returns the name of the model to use for the current user.
    def self.current_user_model_name
      @config_data['current_user_model_name']
    end

    # Returns whatever models should be sanitized on delete.
    def self.task_for_sanitization
      @config_data['task_for_sanitization']
    end
  end
end
