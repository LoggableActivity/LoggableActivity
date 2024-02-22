# frozen_string_literal: true

require 'rails/generators/active_record'
require 'rails/generators/named_base'

module LoggableActivity
  module Generators
    class InstallViewsGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)

      FILE_NAMES = %w[activity payload encryption_key].freeze
      TIME = Time.now

      def create_helper
        template 'helpers/loggable_activity_helper.rb', 'helpers/loggable_activity_helper.rb'
      end

      # def create_views
      #   template 'views/loggable_activity/default/_create.html.erb', 'views/loggable_activity/default/_create.html.erb'
      #   template 'views/loggable_activity/default/_destroy.html.erb', 'views/loggable_activity/default/_destroy.html.erb'
      #   template 'views/loggable_activity/default/_show.html.erb', 'views/loggable_activity/default/_show.html.erb'
      #   template 'views/loggable_activity/default/_update.html.erb', 'views/loggable_activity/default/_update.html.erb'

      #   template 'views/loggable_activity/shared/_activity_info.html.erb', 'views/loggable_activity/shared/_activity_info.html.erb'
      #   template 'views/loggable_activity/shared/_list_attrs.html.erb', 'views/loggable_activity/shared/_list_attrs.html.erb'
      #   template 'views/loggable_activity/shared/_update_attrs.html.erb', 'views/loggable_activity/shared/_update_attrs.html.erb'
      #   template 'views/loggable_activity/shared/_updated_relations.html.erb', 'views/loggable_activity/shared/_updated_relations.html.erb'
      # end

    end
  end
end
