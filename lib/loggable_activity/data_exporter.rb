# frozen_string_literal: true

module LoggableActivity
  # This class creates a csv payload for a given record
  # The csv payload contains all data presented in the payload.activity.attrs
  # The csv file is validated by the schema defined in the csv_schema.json file
  class DataExporter
    require 'csv'

    def initialize(record)
      @record = record
    end

    def export_csv
      generate_csv(fetch_activity_groups)
    end

    # Loads the schema file for the configuration file
    def self.load_schema
      schema_path = File.join(__dir__, 'csv_schema.json')
      JSON.parse(File.read(schema_path))
    end

    private

    def fetch_payloads
      # Fetch all payloads associated with the given record and their activities
      LoggableActivity::Payload
        .where(record: @record)
        .includes(:activity) # Eager load activities to avoid N+1 queries
        .flat_map(&:activity) # Extract activities from payloads
        .flat_map(&:payloads) # Extract payloads from activities
    end

    def fetch_activity_groups
      payloads = fetch_payloads
      payloads_by_activity = payloads.group_by(&:activity)

      payloads_by_activity.map do |activity, payloads|
        {
          activity:,
          payloads:
        }
      end
    end

    def generate_csv(activity_groups)
      csv_data =
        CSV.generate(headers: true) do |csv|
          csv << csv_headers
          activity_groups.each do |activity_group|
            csv << activity_row(activity_group[:activity])
            activity_group[:payloads].each do |payload|
              csv << payload_row(payload)
            end
          end
        end
      validate_csv_data(csv_data)
    end

    def csv_headers
      %w[Date Actor Action type name data]
    end

    def activity_row(activity)
      [
        activity.created_at.strftime('%Y, %B %d %I:%M %p'),
        activity.actor_display_name,
        I18n.t(activity_translation_key(activity.action)),
        '',
        '',
        ''
      ]
    end

    def payload_row(payload)
      [
        '',
        '',
        '',
        payload.record_type,
        payload.payload_display_name,
        format_attrs(payload.attrs)
      ]
    end

    def format_attrs(attrs)
      case attrs
      when Hash
        attrs.map { |k, v| "#{k}: #{format_value(v)}" }.join(', ')
      when Array
        attrs.map { |attr| format_attrs(attr) }.join(', ')
      else
        'nil'
      end
    end

    def format_value(value)
      case value
      when Hash
        value.map { |k, v| "#{k}: #{v}" }.join(', ')
      else
        value.to_s
      end
    end

    def activity_translation_key(action)
      "loggable_activity.#{action}"
    end

    def validate_csv_data(csv_data)
      csv = CSV.parse(csv_data, headers: true)
      json_data = csv.map(&:to_h)

      schema = self.class.load_schema
      errors = JSON::Validator.fully_validate(schema, json_data)
      return csv_data unless errors.any?

      raise ConfigurationError,
            "config/csv_schema.json is invalid: #{errors.join(', ')}"
    end
  end
end
