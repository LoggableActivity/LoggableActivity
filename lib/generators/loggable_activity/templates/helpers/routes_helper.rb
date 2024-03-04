# frozen_string_literal: true

module LoggableActivity
  module RoutesHelper
    include ApplicationHelper

    def url_to_record(route, record)
      case route
      when 'show_doctor', 'show_patient', 'show_user', 'show_user_profile'
        demo_user_url(record)
      when 'show_demo_address'
        demo_city_demo_address_url(record.demo_city, record)
      when 'show_demo_city'
        demo_city_url(record)
      when 'show_demo_journal'
        demo_journal_url(record)
      end
    end
  end
end
