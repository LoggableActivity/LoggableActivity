# frozen_string_literal: true

module LoggableActivity
  # Error class for loggable activity.
  class Error < StandardError
    def initialize(msg = '')
      puts '---------------- LOGGABLE ACTIVITY -----------------'
      puts msg
      puts '----------------------------------------------------'
      super(msg)
    end
  end

  # Error class for encryption.
  class EncryptionError < StandardError
    def initialize(msg = '')
      puts '---------------- LOGGABLE ACTIVITY -----------------'
      puts msg
      puts '----------------------------------------------------'
      super(msg)
    end
  end

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
end
