# frozen_string_literal: true

require 'active_record'

class MockDataOwner < ActiveRecord::Base
  self.table_name = 'mock_data_owners'
  ::LoggableActivity::Configuration.load_config_file('spec/test_files/loggable_activity.yml')
  include LoggableActivity::Hooks
  belongs_to :mock_model
end
