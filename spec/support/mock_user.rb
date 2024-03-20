# frozen_string_literal: true

require 'active_record'

class MockUser < ActiveRecord::Base
  ::LoggableActivity::Configuration.load_config_file('spec/test_files/loggable_activity.yml')
  self.table_name = 'users'
  # has_many :mock_journals, class_name: 'MockJournal'
  include LoggableActivity::Hooks
  belongs_to :mock_journals, class_name: 'MockJournal', optional: true

  def full_name
    "#{name}, email: #{email}"
  end
end
