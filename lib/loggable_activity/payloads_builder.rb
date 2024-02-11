# frozen_string_literal: true

# This is a factory for building payloads.

module LoggableActivity
  module PayloadsBuilder
    def build_payloads
      build_primary_payload
      self.class.relations.each do |relation_config|
        build_relation_payload(relation_config)
      end
      @payloads
    end

    def build_primary_payload
      encrypted_attrs = encrypt_attrs(attributes, self.class.loggable_attrs, primary_encryption_key)
      @payloads << LoggableActivity::Payload.new(
        record: @record,
        payload_type: 'primary_payload',
        encrypted_attrs:,
        data_owner: true
      )
    end

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

    def build_payload(relation_config, ralation_type)
      associated_record = send(relation_config[ralation_type])
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

    def associated_record_encryption_key(associated_record, data_owner)
      if data_owner
        LoggableActivity::EncryptionKey.for_record(associated_record, LoggableActivity::EncryptionKey.for_record(self))
      else
        LoggableActivity::EncryptionKey.for_record(associated_record)
      end
    end

    def encrypt_attrs(attrs, loggable_attrs, encryption_key)
      attrs = attrs.slice(*loggable_attrs)
      encrypt_attr(attrs, encryption_key)
    end

    def encrypt_attr(attrs, encryption_key)
      attrs.each do |key, value|
        attrs[key] = LoggableActivity::Encryption.encrypt(value, encryption_key)
      end
    end
  end
end
