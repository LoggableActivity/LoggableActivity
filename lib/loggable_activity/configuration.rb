# frozen_string_literal: true

module LoggableActivity
  # This class is used to load the configuration file located at config/loggable_activity.yml
  class Configuration
    def self.load_config_file(config_file_path)
      @config_data = YAML.load_file(config_file_path)
    end

    # Returns the configuration data for the given class
    #
    # Example:
    #   LoggableActivity::Configuration.for_class('User')
    # Returns:
    #   {
    #     "record_display_name": "full_name",
    #     "loggable_attrs": [
    #       "first_name",
    #       "last_name",
    #     ],
    #     "auto_log": [
    #       "create",
    #       "update",
    #       "destroy"
    #     ]
    #   }
    def self.for_class(class_name)
      @config_data[class_name]
    end
  end
end
