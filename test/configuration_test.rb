# frozen_string_literal: true

require 'test_helper'

class ConfigurationTest < ActiveSupport::TestCase
  test 'raises ConfigurationError with custom message and prints to stdout' do
    error_message = 'This is a test error message'

    assert_raises(LoggableActivity::ConfigurationError, error_message) do
      raise LoggableActivity::ConfigurationError, error_message
    end
  end

  test 'it has a schema' do
    assert LoggableActivity::Configuration.load_schema
  end

  test 'it loads config data' do
    assert LoggableActivity::Configuration.config_data
  end

  test 'it validate a valid config file' do
    assert LoggableActivity::Configuration.validate_config_file
  end

  test 'it loads config data for a class name' do
    assert_kind_of Hash, LoggableActivity::Configuration.for_class('User')
  end

  test 'it fetch_actor_name_from' do
    assert LoggableActivity::Configuration.fetch_actor_name_from
  end

  test 'it loads task_for_sanitization' do
    refute LoggableActivity::Configuration.task_for_sanitization
  end
end
