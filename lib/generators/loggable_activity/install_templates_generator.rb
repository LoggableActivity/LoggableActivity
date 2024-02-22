# frozen_string_literal: true

require 'rails/generators/base'

module LoggableActivity
  module Generators
    class InstallTemplatesGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      class_option :template, type: :string, default: 'erb'

      def create_helper
        copy_file 'helpers/loggable_activity_helper.rb', 'app/helpers/loggable_activity_helper.rb'
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
