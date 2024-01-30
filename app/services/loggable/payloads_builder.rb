# frozen_string_literal: true
# This it a factory for building payloads.

module Loggable
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

      @payloads << Loggable::Payload.new(
        record: @record,
        payload_type: 'primary_payload',
        encrypted_attrs:
      )
    end

    def build_relation_payload(relation_config)
      relation_config.each_key do |key|
        case key
        when 'belongs_to'
          build_belongs_to_payload(relation_config)
        end
      end
    end

    def build_belongs_to_payload(relation_config)
      associated_record = send(relation_config['belongs_to'])
      return nil if associated_record.nil?

      associated_loggable_attrs = relation_config['loggable_attrs']

      encryption_key = associated_record_encryption_key(associated_record)

      encrypted_attrs =
        encrypt_attrs(
          associated_record.attributes,
          associated_loggable_attrs,
          encryption_key.encryption_key
        )

      @payloads << Loggable::Payload.new(
        record: associated_record,
        encrypted_attrs:,
        payload_type: 'current_association'
      )
      # add_enctyption_key_to_data_owner(associated_record, encryption_key) if relation_config['data_owner']
    end

    # def add_enctyption_key_to_data_owner(associated_record, encryption_key)
    #   Loggable::DataOwnerEncryptionKey.first_or_create!(
    #     encryption_key: encryption_key,
    #     data_owner: associated_record,
    #     record: @record
    #   )
    # end

    def associated_record_encryption_key(record)
      Loggable::EncryptionKey.encryption_key_for_record(record)
    end

    def encrypt_attrs(attrs, loggable_attrs, encryption_key)
      attrs = attrs.slice(*loggable_attrs)
      encrypt_attr(attrs, encryption_key)
    end

    def encrypt_attr(attrs, encryption_key)
      attrs.each do |key, value|
        attrs[key] = Loggable::Encryption.encrypt(value, encryption_key)
      end
    end
  end
end
