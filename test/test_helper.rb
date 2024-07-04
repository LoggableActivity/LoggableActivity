# Load Rails environment
ENV['RAILS_ENV'] = 'test'
require_relative '../test/dummy/config/environment'
ActiveRecord::Migrator.migrations_paths = [File.expand_path('../test/dummy/db/migrate', __dir__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../db/migrate', __dir__)
require 'rails/test_help'
require 'mocha/minitest'
require 'awesome_print'

# Load FactoryBot methods
require 'factory_bot'
FactoryBot.definition_file_paths = [File.expand_path('factories', __dir__)]
FactoryBot.find_definitions


class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
  # Other configuration or setup for your tests
end
