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
require 'support/mock_data_owner'
require 'support/mock_user'
require 'support/mock_parent'
require 'support/mock_child'
require 'support/mock_job'
require 'support/mock_journal'
require 'loggable_activity/activity'
require 'loggable_activity/payload'
require 'factories/users'
require 'factories/loggable_activities'
require 'factories/loggable_payloads'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  create_table :loggable_models, &:timestamps

  create_table :loggable_encryption_keys do |t|
    t.references :record, polymorphic: true, null: true, index: true
    t.string :secret_key
  end

  create_table :loggable_activities do |t|
    t.string :action
    t.references :actor, polymorphic: true, null: true
    t.string :encrypted_actor_name
    t.references :record, polymorphic: true, null: true
    t.timestamps
  end

  create_table :loggable_payloads do |t|
    t.references :activity, null: false, foreign_key: { to_table: 'loggable_activities' }
    t.references :encryption_key, null: false, foreign_key: { to_table: 'loggable_encryption_keys' }
    t.references :record, polymorphic: true, null: true, index: true
    t.string :encrypted_record_name
    t.json :encrypted_attrs
    t.integer :related_to_activity_as, default: 0
    t.boolean :data_owner, default: false
    t.string :route
    t.boolean :current_payload, default: true
  end

  create_table :loggable_data_owners do |t|
    t.references :record, polymorphic: true, null: true, index: true
    t.references :encryption_key, null: false, foreign_key: { to_table: 'loggable_encryption_keys' }
  end

  create_table :users do |t|
    t.string :name
    t.string :email
  end

  create_table :mock_models do |t|
    t.string :first_name
    t.string :last_name
    t.integer :age
    t.string :model_type
    t.timestamps
  end

  create_table :mock_data_owners do |t|
    t.string :name
    t.references :mock_model
  end

  create_table :mock_parents do |t|
    t.string :name
    t.integer :age
  end

  create_table :mock_children do |t|
    t.references :mock_parent
    t.string :name
    t.integer :age
  end

  create_table :mock_jobs do |t|
    t.string :name
    t.integer :wage
    t.belongs_to :mock_parent, index: { unique: true }, foreign_key: false
  end

  create_table :mock_journals do |t|
    t.string :title
    t.text :body
    t.integer :state, default: 0

    t.belongs_to :patient, index: { unique: true }, foreign_key: false
    t.belongs_to :doctor, index: { unique: true }, foreign_key: false
    # t.references :patient, foreign_key: { to_table: :users }, null: true
    # t.references :doctor, foreign_key: { to_table: :users }, null: true
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
