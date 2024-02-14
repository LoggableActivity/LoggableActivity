# frozen_string_literal: true

module LoggableActivity
  # This module is responsible for building payloads used in loggable activities.
  module PayloadsBuilder
    # Builds payloads for the loggable activity.
    #
    #  Example:
    #    build_payloads
    #
    #  Returns:
    #   #<LoggableActivity::Payload:0x0000000109658718> {
    #                    :id => 129,
    #           :record_type => "Demo::Club",
    #             :record_id => 4,
    #       :encrypted_attrs => {
    #           "name" => "z/jigjcm3Fb89L7QT8XiNhvVgjtRXKkmg/xohR6wIc0=\n"
    #       },
    #          :payload_type => "current_association",
    #            :data_owner => nil,
    #           :activity_id => 50,
    #            :created_at => Wed, 14 Feb 2024 13:21:13.964339000 UTC +00:00,
    #            :updated_at => Wed, 14 Feb 2024 13:21:13.964339000 UTC +00:00
    #   }
    #
    def build_payloads
      build_primary_payload
      self.class.relations.each do |relation_config|
        build_relation_payload(relation_config)
      end
      @payloads
    end

    private

    # Builds the primary payload.
    def build_primary_payload
      encrypted_attrs = encrypt_attrs(attributes, self.class.loggable_attrs, primary_encryption_key)
      @payloads << LoggableActivity::Payload.new(
        record: @record,
        payload_type: 'primary_payload',
        encrypted_attrs:,
        data_owner: true
      )
    end

    # Builds the payload for destroyed records.
    def build_destroy_payload
      encrypted_attrs = encrypt_attrs(attributes, self.class.loggable_attrs, primary_encryption_key)
      encrypted_attrs.transform_values! { '*** DELETED ***' }
      @payloads << LoggableActivity::Payload.new(
        record: @record,
        payload_type: 'primary_payload',
        encrypted_attrs:,
        data_owner: true
      )
    end

    # Builds payloads for related records.
    #
    # @param relation_config [Hash] The configuration of the relation.
    def build_relation_payload(relation_config)
      relation_config.each_key do |key|
        case key
        when 'belongs_to'
          build_payload(relation_config, 'belongs_to')
        when 'has_one'
          build_payload(relation_config, 'has_one')
        end
      end
    end

    # Builds the payload for a specific relation.
    #
    # @param relation_config [Hash] The configuration of the relation.
    # @param relation_type [String] The type of the relation.
    def build_payload(relation_config, relation_type)
      associated_record = send(relation_config[relation_type])
      return nil if associated_record.nil?

      associated_loggable_attrs = relation_config['loggable_attrs']

      encryption_key = associated_record_encryption_key(associated_record, relation_config['data_owner'])

      encrypted_attrs =
        encrypt_attrs(
          associated_record.attributes,
          associated_loggable_attrs,
          encryption_key.key
        )

      @payloads << LoggableActivity::Payload.new(
        record: associated_record,
        encrypted_attrs:,
        payload_type: 'current_association',
        data_owner: relation_config['data_owner']
      )
    end

    # Retrieves the encryption key for the associated record.
    #
    # @param associated_record [ActiveRecord::Base] The associated record.
    # @param data_owner [Boolean] Whether the associated record is the owner of the data.
    # @return [LoggableActivity::EncryptionKey] The encryption key for the associated record.
    def associated_record_encryption_key(associated_record, data_owner)
      if data_owner
        LoggableActivity::EncryptionKey.for_record(associated_record, LoggableActivity::EncryptionKey.for_record(self))
      else
        LoggableActivity::EncryptionKey.for_record(associated_record)
      end
    end

    # Encrypts attributes.
    #
    # @param attrs [Hash] The attributes to be encrypted.
    # @param loggable_attrs [Array<String>] The loggable attributes.
    # @param encryption_key [String] The encryption key.
    # @return [Hash] The encrypted attributes.
    def encrypt_attrs(attrs, loggable_attrs, encryption_key)
      attrs = attrs.slice(*loggable_attrs)
      encrypt_attr(attrs, encryption_key)
    end

    # Encrypts a single attribute.
    #
    # @param attrs [Hash] The attributes to be encrypted.
    # @param encryption_key [String] The encryption key.
    # @return [Hash] The encrypted attributes.
    def encrypt_attr(attrs, encryption_key)
      attrs.each do |key, value|
        attrs[key] = LoggableActivity::Encryption.encrypt(value, encryption_key)
      end
    end
  end
end
