# frozen_string_literal: true

require 'rails/generators/base'

module LoggableActivity
  module Generators
    class InstallTemplatesGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      class_option :template, type: :string, default: 'erb'

      def create_helper
        copy_file 'helpers/activity_helper.rb', 'app/helpers/loggable_activity/activity_helper.rb'
        copy_file 'helpers/routes_helper.rb', 'app/helpers/loggable_activity/routes_helper.rb'
        copy_file 'helpers/router.rb', 'app/helpers/loggable_activity/router.rb'
      end

      def create_views
        template_type = options['template']

        case template_type
        when 'slim'
          # Copy slim files
          copy_files('slim')
        else
          # Copy erb files
          copy_files('erb')
        end
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

          LoggableActivity templates installed successfully!

          Quick Start:

          1. Create a new controller to show the list of activities.
            $ rails generate controller LoggableActivities index

          2 Add the following to the loggable_activities_controller.rb
            def index
              @loggable_activities = LoggableActivity::Activity.latest(50)
            end

          3. Update routes.rb
          resources :loggable_activities, only: [:index]

          4. update the index view in app/views/loggable_activities/index.html.TEMPLATE_TYPE
          h1 Activities#{' '}
          table.table#{' '}
            thead
              tr
                th Info#{' '}
                th Attributes
                th Actions
            tbody
              - @loggable_activities.each do |activity|
                = render_activity(activity)

          5. Visit
          http://localhost:3000/loggable_activities



          For more information, please visit:
          https://github.com/maxgronlund/LoggableActivity/blob/main/GETTING-STARTED.md

          Install templates
          $ rails generate loggable_activity:install_templates



          ------------------------------------------------
        MESSAGE

        puts message
      end

      private

      def copy_files(type)
        file_extension = type == 'slim' ? 'html.slim' : 'html.erb'
        %w[create destroy show update].each do |action|
          copy_file "views/loggable_activity/templates/default/_#{action}.#{file_extension}", "app/views/loggable_activity/templates/default/_#{action}.#{file_extension}"
        end
        %w[activity_info list_attrs update_attrs updated_relations].each do |shared|
          copy_file "views/loggable_activity/templates/shared/_#{shared}.#{file_extension}", "app/views/loggable_activity/templates/shared/_#{shared}.#{file_extension}"
        end
      end
    end
  end
end
