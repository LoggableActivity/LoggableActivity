# frozen_string_literal: true

# require 'rails'

require_relative 'loggable_activity/activity'
require_relative 'loggable_activity/configuration'
require_relative 'loggable_activity/encryption'
require_relative 'loggable_activity/encryption_key'
require_relative 'loggable_activity/hooks'
require_relative 'loggable_activity/payload'
require_relative 'loggable_activity/payloads_builder'
require_relative 'loggable_activity/update_payloads_builder'
require_relative 'loggable_activity/version'

module LoggableActivity
  class Error < StandardError; end
  # Your code goes here...
end
