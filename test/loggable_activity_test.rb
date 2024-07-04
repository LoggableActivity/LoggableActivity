# frozen_string_literal: true

require 'test_helper'

class LoggableActivityTest < ActiveSupport::TestCase
  test 'it has a version number' do
    assert LoggableActivity::VERSION
  end

  test 'it has an actor class' do
    assert LoggableActivity.actor_class
  end

  test 'it has a config file path' do
    assert LoggableActivity.config_file_path
  end
end
