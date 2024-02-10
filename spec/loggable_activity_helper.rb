# frozen_string_literal: true

require 'bundler/setup'
require 'rails'
require 'action_view'
require 'action_controller'
require 'rspec/rails'
require 'active_record'
require 'loggable_activity'
require 'loggable_activity/hooks'
# require "loggable_activity/activity"
# require "loggable_activity/services/payloads_builder"

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  create_table :loggable_activity_models, &:timestamps
end

RSpec.configure do |config|
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.order = :random
  Kernel.srand config.seed
end
