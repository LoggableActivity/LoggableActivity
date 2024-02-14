# frozen_string_literal: true

require 'rails/generators/active_record'
require 'rails/generators/named_base'

module LoggableActivity
  module Generators
    class InstallGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)

      FILE_NAMES = %w[activity payload encryption_key].freeze
      TIME = Time.now

      def create_migration
        time = Time.now.utc
        FILE_NAMES.each_with_index do |file_name, index|
          timestamp = (time + index.minutes).strftime('%Y%m%d%H%M%S')
          migration_file_name = "create_loggable_#{file_name.pluralize}.rb"
          destination = File.join('db', 'migrate', "#{timestamp}_#{migration_file_name}")
          template migration_file_name, destination
        end
      end

      def create_model_file
        template 'loggable_activity.en.yml', 'config/locales/loggable_activity.en.yml'
        template 'loggable_activity.yml', 'config/loggable_activity.yml'
        template "current_user.rb", 'app/controllers/concerns/loggable_activity/current_user.rb'
      end
    end
  end
end
