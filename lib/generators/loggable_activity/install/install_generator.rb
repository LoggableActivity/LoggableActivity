module LoggableActivity
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      desc "Creates a LoggableActivity initializer in your application."
      def copy_initializer
        template 'loggable_activity.rb', 'config/initializers/loggable_activity.rb'
      end

      desc "Creates a migration file for LoggableActivity in your application."
      def copy_migration
        template 'create_loggable_activities.rb', "db/migrate/#{migration_number}_create_loggable_activities.rb"
      end

      desc "Creates a locale file for LoggableActivity in your application."
      def copy_locale
        template 'loggable_activity.en.yml', "config/locales/loggable_activity.en.yml"
      end

      def migration_number
        Time.now.utc.strftime('%Y%m%d%H%M%S')
      end

      puts ''
      puts "\e[1m\e[32m* ----------------------------- LoggableActivity ----------------------------- *\e[0m"
      puts "\e[1m\e[32m*                                                                              *\e[0m"
      puts "\e[1m\e[32m* LoggableActivity has been successfully installed.                            *\e[0m"
      puts "\e[1m\e[32m* Add the following to your routes.rb file.                                    *\e[0m"
      puts "\e[1m\e[32m* Mount LoggableActivity::Engine => '/loggable_activity'                       *\e[0m"
      puts "\e[1m\e[32m*                                                                              *\e[0m"
      puts "\e[1m\e[32m* $ rails db:migrate to create the tables.                                       *\e[0m"
      puts "\e[1m\e[32m*                                                                              *\e[0m"
      puts "\e[1m\e[32m* Add include LoggableActivity::Hook to the models you want to track.          *\e[0m"
      puts "\e[1m\e[32m*                                                                              *\e[0m"
      puts "\e[1m\e[32m* Update the config/loggable_activity.yaml file with fields to track.          *\e[0m"
      puts "\e[1m\e[32m*                                                                              *\e[0m"
      puts "\e[1m\e[32m* Locale files are found in config/locale/loggable_activity.en.yaml.           *\e[0m"
      puts "\e[1m\e[32m*                                                                              *\e[0m"
      puts "\e[1m\e[32m* ---------------------------------------------------------------------------- *\e[0m"
      puts ''
    end
  end
end
