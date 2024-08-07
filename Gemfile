# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in loggable_activity.gemspec.
gemspec

gem 'puma'

gem 'sqlite3', '~> 1.4.2'

gem 'sprockets-rails'

gem 'sassc-rails'

gem 'kaminari', '~> 1.2', '>= 1.2.2'

# Use Slim as template language
gem 'slim-rails', '~> 3.6', '>= 3.6.3'

# Use RabbitMQ for message queueing
gem 'bunny', '~> 2.23'

gem 'ransack', '~> 4.2'

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"
group :development, :test do
  gem 'awesome_print', '~> 1.9', '>= 1.9.2'
  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.3'
  gem 'faker', '~> 3.4', '>= 3.4.1'
  gem 'mocha', '~> 2.4'
  gem 'rubocop', '~> 1.60', '>= 1.60.2'
  gem 'rubocop-factory_bot', '~> 2.26', '>= 2.26.1'
  gem 'rubocop-minitest', '~> 0.35.1'
  gem 'rubocop-rails', '~> 2.25', '>= 2.25.1'
end
