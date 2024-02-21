# frozen_string_literal: true

require 'bundler/setup'
require 'loggable_activity'
require 'rails'
require 'action_view'
require 'action_controller'
require 'rspec/rails'
require 'active_record'
require 'factory_bot'
require 'support/mock_model'
require 'support/mock_user'
require 'support/mock_parent'
require 'support/mock_child'
require 'loggable_activity/activity'
require 'loggable_activity/payload'
require 'factories/users'
require 'factories/loggable_activities'
require 'factories/loggable_payloads'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  create_table :loggable_models, &:timestamps

  create_table :loggable_encryption_keys do |t|
    t.string :record_type
    t.integer :record_id
    t.string :key
    t.integer :parent_key_id
    t.timestamps
  end

  create_table :loggable_payloads do |t|
    t.references :record, polymorphic: true, null: true
    t.json :encrypted_attrs
    t.integer :payload_type, default: 0
    t.boolean :data_owner, default: false
    t.references :activity, foreign_key: { to_table: 'loggable_activities', class_name: 'LoggableActivity::Activity' }

    t.timestamps
  end

  create_table :loggable_activities do |t|
    t.string :action
    t.references :actor, polymorphic: true, null: true
    t.string :encrypted_actor_display_name
    t.string :encrypted_record_display_name
    t.references :record, polymorphic: true, null: true

    t.timestamps
  end

  create_table :users do |t|
    t.string :name
    t.string :email
    t.timestamps
  end

  create_table :mock_models do |t|
    t.string :first_name
    t.string :last_name
    t.integer :age
    t.string :model_type
    t.timestamps
  end

  create_table :mock_parents do |t|
    t.string :name
    t.integer :age
    t.timestamps
  end

  create_table :mock_children do |t|
    t.references :mock_parent
    t.string :name
    t.integer :age
    t.timestamps
  end
end

RSpec.configure do |config|
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'spec/examples.txt'
  # config.disable_monkey_patching!
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.order = :random
  Kernel.srand config.seed
end
