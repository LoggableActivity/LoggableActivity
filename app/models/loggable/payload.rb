# frozen_string_literal: true
# This is the payload of the log. It contains the encrypted data of one record in the DB.
# When the record is deleted, the encryption_key for the payload is deleted.
# Payloads comes in different flavors. 
# The primary_payload is the payload that contains the parrent record.
# When fecthing the attrs, they are packed differently depending on the payload_type.

module Loggable
  class Payload < ApplicationRecord
    belongs_to :activity
    belongs_to :record, polymorphic: true, optional: true
    validates :encrypted_attrs, presence: true
    enum payload_type: {
      primary_payload: 0,
      update_payload: 1,
      current_association: 2,
      previous_association: 3,
      destroy_payload: 4
    }

    def attrs
      case payload_type
      when 'current_association', 'primary_payload', 'previous_association'
        decrypted_attrs
      when 'update_payload'
        decrypted_update_attrs
      end
    end

    private

    def decrypted_update_attrs
      encrypted_attrs['changes'].map do |change|
        decrypted_from_to_attr(change)
      end
    end

    def decrypted_from_to_attr(change)
      encryption_key = encryption_key_for_record(record)
      change.to_h do |key, value|
        from = decrypt_attr(value['from'], encryption_key)
        to = decrypt_attr(value['to'], encryption_key)
        [key, { from:, to: }]
      end
    end

    def decrypted_attrs
      encryption_key = encryption_key_for_record(record)

      encrypted_attrs.each do |key, value|
        encrypted_attrs[key] = decrypt_attr(value, encryption_key)
      end
    end

    def encryption_key_for_record(record)
      Loggable::EncryptionKey.encryption_key_for_record(record)&.encryption_key
    end

    def decrypt_attr(value, encryption_key)
      Loggable::Encryption.decrypt(value, encryption_key)
    end
  end
end
