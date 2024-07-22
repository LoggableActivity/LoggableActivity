# frozen_string_literal: true

require 'test_helper'

module LoggableActivity
  class DataExporterTest < ActiveSupport::TestCase
    setup do
      Thread.current[:current_actor] = @current_user = create(:user, user_type: 'admin')
      # @company = Company.create(name: 'Company')
    end

    test 'export_csv returns a CSV file' do
      record =
        User.create(
          first_name: 'John',
          last_name: 'Doe',
          email: 'john-doe@example.com',
          password: 'password',
          age: 30,
          user_type: 'admin',
          company: @current_user.company
        )
      record.update(first_name: 'Jane')
      activity = LoggableActivity::Activity.last
      activity.update(created_at: 6.seconds.ago)
      record.log(:show)
      Hat.create(color: 'Cyan', user: record)
      record.reload.hats
      record.destroy
      exporter = LoggableActivity::DataExporter.new(record)
      csv_data = exporter.export_csv
      assert_instance_of(String, csv_data)
    end
  end
end
