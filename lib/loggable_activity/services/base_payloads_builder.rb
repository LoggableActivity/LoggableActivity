# frozen_string_literal: true

module LoggableActivity
  module Services
    # This service class provides the base payloads builder for the loggable activity.
    # Other service modules related to the loggable activity will inherit from this module.
    class BasePayloadsBuilder
      # Initializes the PayloadsBuilder with a record and an initial collection of payloads,
      def initialize(record, payloads, params = {})
        @record = record
        @payloads = payloads
        @params = params
        @loggable_attrs = record.class.loggable_attrs
        @public_attrs = record.class.public_attrs
        # @relation_config = record.relation_config
        @relations = record.class.relations
        @auto_log = record.class.auto_log
        # @fetch_record_name_from = record.class.fetch_record_name_from
        @route = record.class.route
      end

      private

      # Returns saved changes for a record.
      def saved_changes(record)
        [record.saved_changes.transform_values(&:first), record.saved_changes.transform_values(&:last)]
      end

      # Fetch the previous and current values for a record.
      def changes_to_save(record)
        changes = record.changes_to_save
        previous_values = {}
        current_values = {}

        changes.map do |key, value|
          previous_values[key] = value[0]
          current_values[key] = value[1]
        end
        [previous_values, current_values]
      end

      # Encrypts the record name for the record.
      # If the record has a fetch_record_name_from the configuration,
      # it will use that method to fetch the record name.
      # Otherwise, it will use the class name and the record id.
      def encrypt_record_name_for_record(record, secret_key)
        record_name = fetch_record_name_for_record(record) || "#{record.class.name}##{record.id}"

        ::LoggableActivity::Encryption.encrypt(record_name, secret_key)
      end

      # Return the record name for the record.
      # If the record has a fetch_record_name_from the configuration,
      def fetch_record_name_for_record(record)
        fetch_from = record.class.fetch_record_name_from
        return nil if fetch_from.nil?

        record.send(fetch_from)
      end

      # Returns the encryption key for the record.
      def encryption_key_for_record(record)
        ::LoggableActivity::EncryptionKey.for_record(record)
      end

      # Build a encrypted payload for a record
      def build_encrypted_payload(record, options = {})
        encryption_key = encryption_key_for_record(record)
        return if encryption_key.deleted?

        secret_key = encryption_key.secret_key
        encrypted_attrs = encrypt_attributes(record, secret_key, options)
        public_attrs = public_attributes(record)

        build_payload(
          record,
          encryption_key,
          encrypted_attrs,
          public_attrs,
          options
        )
        { encryption_key:, encrypted_attrs: }
      end

      # Builds the payload for a record
      def build_payload(record, encryption_key, encrypted_attrs, public_attrs, options = {})
        return if encryption_key.deleted?

        related_to_activity_as = options[:related_to_activity_as]
        current_payload = options[:current_payload]
        data_owner = options[:data_owner]

        secret_key = encryption_key.secret_key
        encrypted_record_name = encrypt_record_name_for_record(record, secret_key)
        payload = ::LoggableActivity::Payload.new(
          encryption_key:,
          record:,
          encrypted_record_name:,
          encrypted_attrs:,
          related_to_activity_as:,
          route: record.class.route,
          current_payload:,
          data_owner:,
          public_attrs:
        )
        unless payload.valid?
          error_message = "Payload validation failed: #{payload.errors.full_messages.join(', ')}"
          raise LoggableActivity::Error, error_message
        end

        @payloads << payload
      end

      # Encrypts the attributes for the record.
      def encrypt_attributes(record, secret_key, options = {})
        loggable_attrs = options[:loggable_attrs] || record.class.loggable_attrs
        encrypt_attrs(record.attributes, loggable_attrs, secret_key)
      end

      # Encrypt one attributes for only loggable_attrs, configured
      def encrypt_attrs(attrs, loggable_attrs, secret_key)
        attrs.slice(*loggable_attrs).transform_values do |value|
          ::LoggableActivity::Encryption.encrypt(value, secret_key)
        end
      end

      def public_attributes(record)
        record.attributes.slice(*record.class.public_attrs)
      end

      # Encrypt a single attribute.
      def encrypt_attr(value, secret_key)
        ::LoggableActivity::Encryption.encrypt(value, secret_key)
      end
    end
  end
end
