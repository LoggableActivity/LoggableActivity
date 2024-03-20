# frozen_string_literal: true

require 'active_record'

class MockParent < ActiveRecord::Base
  self.table_name = 'mock_parents'
  ::LoggableActivity::Configuration.load_config_file('spec/test_files/loggable_activity.yml')
  include LoggableActivity::Hooks
  has_many :mock_children, dependent: :destroy
  accepts_nested_attributes_for :mock_children
  has_one :mock_job, class_name: 'MockJob', dependent: :destroy
  accepts_nested_attributes_for :mock_job
end
