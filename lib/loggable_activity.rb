# frozen_string_literal: true

require 'loggable_activity/version'
require 'loggable_activity/engine'
require 'loggable_activity/hooks'
require 'loggable_activity/activity'
require 'loggable_activity/configuration'
require 'loggable_activity/encryption'
require 'loggable_activity/encryption_key'
require 'loggable_activity/data_owner'
require 'loggable_activity/payload'
require 'loggable_activity/error'
require 'loggable_activity/sanitizer'
require 'loggable_activity/services/base_payloads_builder'
require 'loggable_activity/services/payloads_builder'
require 'loggable_activity/services/update_payloads_builder'
require 'loggable_activity/services/destroy_payloads_builder'
require 'loggable_activity/concerns/current_user'

module LoggableActivity
  mattr_accessor :actor_class
  mattr_accessor :config_file_path

  # Your code goes here...
end
