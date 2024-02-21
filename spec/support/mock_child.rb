# frozen_string_literal: true

require 'active_record'

class MockChild < ActiveRecord::Base
  self.table_name = 'mock_children'
  LoggableActivity::Configuration.load_config_file('spec/test_files/loggable_activity_test.yml')
  include LoggableActivity::Hooks
  belongs_to :mock_parent
end
