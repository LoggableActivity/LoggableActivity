# frozen_string_literal: true

module LoggableActivity
  # Engine
  #
  # This module defines the LoggableActivity engine for use within a Rails application.
  # It leverages Rails::Engine to create an isolated namespace, ensuring that the components
  # of the LoggableActivity engine (such as models, controllers, and views) do not interfere
  # with those of the host application or other engines.
  #
  # Example Usage:
  # In a Rails application, you can mount this engine to make its functionality available:
  #
  #   mount LoggableActivity::Engine, at: "/loggable_activity"
  #
  # This will allow the application to utilize the features provided by the LoggableActivity engine
  # under the specified mount path.
  #
  class Engine < ::Rails::Engine
    isolate_namespace LoggableActivity
  end
end
