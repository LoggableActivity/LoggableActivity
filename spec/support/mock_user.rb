# frozen_string_literal: true

require 'active_record'

class MockUser < ActiveRecord::Base
  self.table_name = 'users'
  # include LoggableActivity::Hooks
  def full_name
    'John Doe'
  end
end
