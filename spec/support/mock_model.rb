# frozen_string_literal: true

require 'active_record'

class MockModel < ActiveRecord::Base
  self.table_name = 'mock_models'
  ::LoggableActivity::Configuration.load_config_file('spec/test_files/loggable_activity.yml')
  include LoggableActivity::Hooks

  has_many :mock_data_owners, dependent: :destroy
  accepts_nested_attributes_for :mock_data_owners

  def full_name
    "#{first_name} #{last_name}"
  end
end
