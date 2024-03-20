# frozen_string_literal: true

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

  class Configuration
    # Loads the configuration file
    def self.load_config_file(config_file_path)
      @config_data = YAML.load_file(config_file_path)
      validate_config_data
    rescue Errno::ENOENT
      raise ConfigurationError, 'config/loggable_activity.yaml not found'
    end

    def self.validate_config_data
      validate_current_user_model_name
      validate_fetch_current_user_name_from
    end

    def self.validate_current_user_model_name
      return unless current_user_model_name.nil?

      raise ConfigurationError,
            'current_user_model_name missing, ' \
            'Please add it to config/loggable_activity.yaml'
    end

    def self.validate_fetch_current_user_name_from
      return unless fetch_current_user_name_from.nil?

      raise ConfigurationError,
            'fetch_current_user_name_from missing, ' \
            'Please add it to config/loggable_activity.yaml'
    end

    def self.loaded?
      !@config_data.nil?
    end

    # Returns the configuration data
    def self.config_data
      @config_data
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
  end
end
