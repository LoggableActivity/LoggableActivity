# frozen_string_literal: true

module LoggableActivity
  class Configuration
    def self.load_config_file(config_file_path)
      @config_data = YAML.load_file(config_file_path)
    end

    def self.for_class(class_name)
      @config_data[class_name]
    end
  end
end
