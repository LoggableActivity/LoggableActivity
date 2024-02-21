# frozen_string_literal: true

require 'active_record'

class MockParent < ActiveRecord::Base
  self.table_name = 'mock_parents'
  LoggableActivity::Configuration.load_config_file('spec/test_files/loggable_activity_test.yml')
  include LoggableActivity::Hooks
  has_many :mock_children
end
