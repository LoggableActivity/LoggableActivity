# frozen_string_literal: true

require 'rails'

require_relative 'loggable_activity/activity'
require_relative 'loggable_activity/configuration'
require_relative 'loggable_activity/encryption'
require_relative 'loggable_activity/encryption_key'
require_relative 'loggable_activity/hooks'
require_relative 'loggable_activity/payload'
require_relative 'loggable_activity/payloads_builder'
require_relative 'loggable_activity/update_payloads_builder'
require_relative 'loggable_activity/version'

# require_relative "loggable_activity/version"
# require 'active_record'
# require 'rails/application_record'

# require 'loggable_activity/hooks'
# require 'loggable_activity/payloads_builder'
# require 'loggable_activity/update_payloads_builder'
# require 'loggable_activity/activity'
# require 'loggable_activity/payload'
# require 'loggable_activity/encryption_key'
# require 'loggable_activity/enigma'
# require 'loggable_activity/configuration'
# require 'loggable_activity/activity'

module LoggableActivity
  class Error < StandardError; end
  # Your code goes here...
end
