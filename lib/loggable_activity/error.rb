# frozen_string_literal: true

module LoggableActivity
  # Error class for loggable activity.
  class Error < StandardError
    def initialize(msg = '')
      super
    end
  end

  # Error class for encryption.
  class EncryptionError < StandardError
    def initialize(msg = '')
      super
    end
  end

  # This class is used to load the configuration file located at config/loggable_activity.yml
  class ConfigurationError < StandardError
    def initialize(msg = '')
      super
    end
  end
end
