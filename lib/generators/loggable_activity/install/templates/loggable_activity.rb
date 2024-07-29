# frozen_string_literal: true

# This configuration file is for setting up the LoggableActivity gem in your Rails application.

# Specify the name of the model that represents the actor performing the activities.
# This should be a string that matches the class name of the model.
# Example: If your user model is named "User", set it to 'User'.
LoggableActivity.actor_model_name = 'User'

# Specify the attribute from which to fetch the actor's name.
# This should be eighter a string representing the attribute name of the actor model
# or a method that returns the actor's name.
# Example: If you want to use the user's email as their name, set it to 'email'.
LoggableActivity.fetch_actor_name_from = 'email'

# Specify the path to the configuration file for LoggableActivity.
# This file should be a YAML file that contains the necessary configuration for logging activities.
# The path is set relative to the Rails root directory.
# Example: The default configuration file path is 'config/loggable_activity.yml'.
LoggableActivity.config_file_path = Rails.root.join('config/loggable_activity.yml')

# Specify whether the sanitazion should be performed by a task or not
# If set to 'false' the sanitization is performed immediately.
# If set to 'true' the data is inaccessible, but can be restored.
# If set to 'true' you have to permanently delete
# the data by calling 'LoggableActivity::Sanitizer.run' from a task.
LoggableActivity.task_for_sanitization = false

# Specify whether to call the endpoint or not
# If set to 'true' the endpoint is called
# If set to 'false' the endpoint is not called
LoggableActivity.call_endpoint = false
