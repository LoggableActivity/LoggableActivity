# frozen_string_literal: true

require 'active_record'

class MockJob < ActiveRecord::Base
  ::LoggableActivity::Configuration.load_config_file('spec/test_files/loggable_activity.yml')
  self.table_name = 'mock_jobs'
  include LoggableActivity::Hooks
  belongs_to :mock_parent, class_name: 'MockParent', foreign_key: :mock_parent_id, optional: true
end
