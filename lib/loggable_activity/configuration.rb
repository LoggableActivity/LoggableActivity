# frozen_string_literal: true

require 'json-schema'
require 'json'

module LoggableActivity
  # This class is used to load the configuration file located at config/loggable_activity.yml
  # When the LoggableActivity::Hook is included in a model
  # it takes the model's name and find the configuration for that model in the configuration file.
  class Configuration
    class << self
      # Loads the schema file for the configuration file
      def load_schema
        schema_path = File.join(__dir__, 'config_schema.json')
        JSON.parse(File.read(schema_path))
      end

      # Loads the configuration file, and store it as a hash
      def config_data
        @config_data ||= YAML.load_file(LoggableActivity.config_file_path)
      end

      # Validates the configuration file againss the schema
      def validate_config_file
        schema = load_schema
        errors = JSON::Validator.fully_validate(schema, config_data)
        return true unless errors.any?

        raise ConfigurationError,
              "config/loggable_activity.yaml is invalid: #{errors.join(', ')}"
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
      def for_class(class_name)
        config_data[class_name]
      end
    end
  end
end
