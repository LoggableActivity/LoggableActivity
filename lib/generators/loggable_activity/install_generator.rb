# frozen_string_literal: true

require 'rails/generators/active_record'
require 'rails/generators/named_base'

module LoggableActivity
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def self.banner
        'rails generate loggable_activity:install [options]'
      end

      desc 'This generator configures LoggableActivity by creating migration files and initializing necessary configuration files.'

      source_root File.expand_path('templates', __dir__)
      class_option :uuid, type: :boolean, desc: 'use UUID for primary keys'

      FILE_NAMES = %w[activity payload encryption_key data_owner].freeze
      TIME = Time.now

      def install
        binary_ids = options['uuid'] ? true : false
        time = Time.now.utc
        timestamp = time.strftime('%Y%m%d%H%M%S')
        migration_file_name = 'create_loggable_activities.rb'
        destination = File.join('db', 'migrate', "#{timestamp}_#{migration_file_name}")
        if binary_ids
          template "binary_ids/#{migration_file_name}", destination
        else
          template migration_file_name, destination
        end
      end

      def create_translation_file
        copy_file 'config/locales/loggable_activity.en.yml', 'config/locales/loggable_activity.en.yml'
      end

      def create_config_file
        copy_file 'config/loggable_activity.yaml', 'config/loggable_activity.yaml'
      end

      def create_current_user_concern
        copy_file 'current_user.rb', 'app/controllers/concerns/loggable_activity/current_user.rb'
      end

      def completion_message
        message = <<~MESSAGE
          ------------------------------------------------
           ___             _        _       _   _#{'             '}
          |_ _|  _ __  ___| |_ __ _| | __ _| |_(_) ___  _ __#{'  '}
           | |  | '_ \\/ __| __/ _` | |/ _` | __| |/ _ \\| '_ \\#{' '}
           | |  | | | \\__ \\ || (_| | | (_| | |_| | (_) | | | |
          |___| |_| |_|___/\\__\\__,_|_|\\__,_|\\__|_|\\___/|_| |_|
            ____                         _      _           _#{' '}
           / ___|   ___  _ __ ___  _ __ | | ___| |_ ___  __| |
          | |      / _ \\| '_ ` _ \\| '_ \\| |/ _ \\ __/ _ \\/ _` |
          | |___  | (_) | | | | | | |_) | |  __/ ||  __/ (_| |
           \\____|  \\___/|_| |_| |_| .__/|_|\\___|\\__\\___|\\__,_|
                                  |_|#{'                                               '}

          LoggableActivity installation completed successfully!

          Quick Start:

          1. include hooks to the model we want to log.
            class MY_MODEL < ApplicationRecord
              include LoggableActivity::Hooks

          2. Update `config/application.rb
            config.loggable_activity = ActiveSupport::OrderedOptions.new
            ::LoggableActivity::Configuration.load_config_file('config/loggable_activity.yaml')

          3. Include current_user ApplicationController
            class ApplicationController < ActionController::Base
              include LoggableActivity::CurrentUser

          4. Update the 'config/loggable_activity.yaml' file with the necessary configuration.

          5. Run the migration to create the necessary tables.


          For more information, please visit:
          https://github.com/maxgronlund/LoggableActivity/blob/main/GETTING-STARTED.md

          ------------------------------------------------
        MESSAGE

        puts message
      end

      private

      def create_migration_files
        binary_ids = options['uuid'] ? true : false
        time = Time.now.utc
        timestamp = time.strftime('%Y%m%d%H%M%S')
        migration_file_name = 'create_loggable_activities.rb'
        destination = File.join('db', 'migrate', "#{timestamp}_#{migration_file_name}")
        if binary_ids
          # Copy binary_id migration file
          template "binary_ids/#{migration_file_name}", destination
        else
          # Copy integer migration file
          template migration_file_name, destination
        end
      end
    end
  end
end
