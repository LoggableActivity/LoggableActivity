# frozen_string_literal: true

require 'spec_helper'
require 'generator_spec'
require 'generators/loggable_activity/install_generator'

RSpec.describe LoggableActivity::Generators::InstallGenerator, type: :generator do
  destination File.expand_path('../tmp', __dir__)
  # arguments %w()

  before do
    prepare_destination
    run_generator
  end

  it 'creates the migrations' do
    migration_path = File.join(destination_root, 'db/migrate')
    expect(File.exist?(migration_path)).to be true
    migration_files = Dir.entries(migration_path)
    expect(migration_files).to include(/create_loggable_activities/)
    # expect(migration_files).to include(/create_loggable_payloads/)
    # expect(migration_files).to include(/create_loggable_encryption_keys/)
  end

  # it 'creates the models' do
  #   model_path = "#{destination_root}/app/models/comment.rb"
  #   expect(File.exist?(model_path)).to be true
  #   model_contents = File.read(model_path)
  #   expect(model_contents).to match(/class Comment < ApplicationRecord/)
  # end

  after(:all) do
    FileUtils.rm_rf(destination_root)
  end
end
