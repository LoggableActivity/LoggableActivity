# frozen_string_literal: true

require 'active_record'

class MockModel < ActiveRecord::Base
  self.table_name = 'mock_models'
  LoggableActivity::Configuration.load_config_file('spec/test_files/loggable_activity_test.yml')
  include LoggableActivity::Hooks

  def full_name
    "#{first_name} #{last_name}"
  end
end
