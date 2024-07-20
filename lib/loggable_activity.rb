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
require 'loggable_activity/services/custom_payloads_builder'
require 'loggable_activity/services/payloads_builder'
require 'loggable_activity/services/update_payloads_builder'
require 'loggable_activity/services/destroy_payloads_builder'
require 'loggable_activity/services/rabbitmq_publisher'
require 'loggable_activity/services/endpoint_caller'
require 'loggable_activity/concerns/current_actor'
require 'kaminari'

# LoggableActivity
#
# The LoggableActivity module provides a comprehensive solution for tracking and logging
# user activities within a Rails application. It offers a flexible and extensible framework
# for capturing, encrypting, and storing activity data, ensuring that sensitive information
# is handled securely.
#
# Features:
# - Activity Logging: Captures user actions across the application, providing insights into user behavior.
# - Encryption: Ensures that logged data is encrypted, safeguarding user privacy and data security.
# - Configuration: Offers customizable options to tailor the logging mechanism to specific application needs.
# - Extensibility: Designed to be extensible, allowing developers to add custom logging capabilities as needed.
#
# Components:
# - Hooks: Mechanisms to hook into application events for logging.
# - Activity: The core model representing logged activities.
# - Configuration: Manages configuration settings for the logging mechanism.
# - Encryption: Handles the encryption and decryption of logged data.
# - DataOwner: Identifies the owner of the logged data.
# - Payload: Structures the data to be logged.
# - Error: Defines custom error types for the logging process.
# - Sanitizer: Provides data sanitization utilities.
# - Services: Contains services for building and managing payloads.
# - Concerns: Includes concerns for integrating with application models and controllers.
#
# Usage:
# To use LoggableActivity, include it in your Rails application and configure it according to your needs.
#
# This module is designed to be both powerful and easy to integrate, providing a solid foundation for activity logging.
module LoggableActivity
  mattr_accessor :actor_model_name
  mattr_accessor :fetch_actor_name_from
  mattr_accessor :config_file_path
  mattr_accessor :task_for_sanitization
  mattr_accessor :call_endpoint
end
