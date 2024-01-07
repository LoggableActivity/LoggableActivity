module Loggable
  class Configuration
    CONFIG = YAML.load_file(Rails.root.join('config', 'loggable_activity.yaml')).freeze

    def self.for_class(class_name)
      CONFIG[class_name]
    end
  end
end
