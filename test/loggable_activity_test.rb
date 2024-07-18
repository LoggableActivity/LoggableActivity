# frozen_string_literal: true

require 'test_helper'

class LoggableActivityTest < ActiveSupport::TestCase
  test 'it has a version number' do
    assert LoggableActivity::VERSION
  end

  test 'it actor_model_name' do
    assert LoggableActivity.actor_model_name
  end

  test 'it fetch_actorname_from' do
    assert LoggableActivity.actor_model_name
  end

  test 'it has a config file path' do
    assert LoggableActivity.config_file_path
  end
end
