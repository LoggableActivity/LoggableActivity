# frozen_string_literal: true

module LoggableActivity
  module Services
    # This service class builds custom payloads.
    class CustomPayloadsBuilder < BasePayloadsBuilder
      # Builds a custom payloads for a ::LoggableActivity::Activity.
      def build
        encryption_key = encryption_key_for_record(@record)
        @secret_key = encryption_key&.secret_key
        encrypted_attrs = build_custom_payloads(@params)

        payload = ::LoggableActivity::Payload.new(
          encryption_key:,
          record: @record,
          encrypted_record_name:,
          encrypted_attrs:,
          related_to_activity_as: 'custom_payload',
          route: @record.class.route,
          current_payload: true,
          data_owner: @record,
          public_attrs: {}
        )

        unless payload.valid?
          error_message = "Payload validation failed: #{payload.errors.full_messages.join(', ')}"
          raise LoggableActivity::Error, error_message
        end

        @payloads << payload
      end

      private

      def encrypted_record_name
        return encrypt_attr(@params[:display_name], @secret_key) if @params[:display_name]

        encrypt_record_name_for_record(@record, @secret_key)
      end

      def build_custom_payloads(params)
        params.transform_values do |value|
          case value
          when Hash
            build_custom_payloads(value)
          when Array
            value.map { |v| v.is_a?(Hash) ? build_custom_payloads(v) : encrypt_attr(v, @secret_key) }
          else
            encrypt_attr(value, @secret_key)
          end
        end
      end
    end
  end
end
