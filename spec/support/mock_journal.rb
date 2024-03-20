# frozen_string_literal: true

require 'active_record'

class MockJournal < ActiveRecord::Base
  ::LoggableActivity::Configuration.load_config_file('spec/test_files/loggable_activity.yml')
  self.table_name = 'mock_journals'
  belongs_to :patient, class_name: 'MockUser', optional: true
  belongs_to :doctor, class_name: 'MockUser', optional: true

  include LoggableActivity::Hooks
end
