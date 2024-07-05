# frozen_string_literal: true

require_relative 'lib/loggable_activity/version'

Gem::Specification.new do |spec|
  spec.name = 'loggable_activity'
  spec.version = LoggableActivity::VERSION
  spec.authors = ["Max \nGroenlund"]
  spec.email = ['max@synthmax.dk']

  spec.summary = 'Activity Logger with relations, prepared for GDPR Compliance and .'
  spec.description = <<-DESC
    LoggableActivity is a powerful gem for Ruby on Rails that provides seamless user activity logging
    prepared for GDPR compliance and supporting record relations. It allows you to effortlessly
    keep track of user actions within your application, capturing who did what and when, even with
    related records included in the logs. With LoggableActivity, you can maintain the privacy of
    sensitive information in your logs, making it a perfect solution for applications that require
    robust audit trails while adhering to strict data protection regulations.
  DESC
  spec.homepage = 'https://loggableactivity-efe7b931c886.herokuapp.com/'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"
  spec.metadata['homepage_uri'] = spec.homepage

  spec.metadata = {
    'homepage_uri' => 'https://loggableactivity-efe7b931c886.herokuapp.com/',
    'source_code_uri' => 'https://github.com/LoggableActivity/LoggableActivity',
    'changelog_uri' => 'https://github.com/LoggableActivity/LoggableActivity/CHANGELOG.md',
    'documentation_uri' => 'https://LoggableActivity.github.io/LoggableActivity/',
    'rubygems_mfa_required' => 'true'
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '~> 7.1.3'
  spec.add_dependency 'bootstrap', '~> 5.3', '>= 5.3.3'
  spec.add_dependency 'bootstrap5-kaminari-views', '~> 0.0.1'
  spec.add_dependency 'json-schema', '~> 4.1', '>= 4.1.1'
  spec.add_dependency 'kaminari', '~> 1.2', '>= 1.2.2'
  spec.add_dependency 'rails', '~> 7.1.2'
  spec.add_dependency 'sassc-rails', '~> 2.1', '>= 2.1.2'

  # spec.add_development_dependency 'generator_spec', '~> 0.10.0'
  # spec.add_development_dependency 'rspec-mocks', '~> 3.13'
  # spec.add_development_dependency 'rspec-rails', '~> 6.1', '>= 6.1.1'
  spec.add_development_dependency 'sqlite3', '~> 1.4.2'

  spec.add_development_dependency 'awesome_print', '~> 1.9', '>= 1.9.2'
  spec.add_development_dependency 'factory_bot_rails', '~> 6.4', '>= 6.4.3'
  spec.add_development_dependency 'faker', '~> 3.4', '>= 3.4.1'
  spec.add_development_dependency 'mocha', '~> 2.4'
  spec.add_development_dependency 'rubocop', '~> 1.60', '>= 1.60.2'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
