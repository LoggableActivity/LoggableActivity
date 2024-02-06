# frozen_string_literal: true

# This is the payload of the log. It contains the encrypted data of one record in the DB.
# When the record is deleted, the encryption_key for the payload is deleted.
# Payloads comes in different flavors.
# The primary_payload is the payload that contains the parrent record.
# When fecthing the attrs, they are packed differently depending on the payload_type.

module Loggable
  class Payload < ApplicationRecord
    belongs_to :record, polymorphic: true, optional: true

    belongs_to :activity
    belongs_to :record, polymorphic: true, optional: true
    validates :encrypted_attrs, presence: true
    enum payload_type: {
      primary_payload: 0,
      update_payload: 1,
      current_association: 2,
      previous_association: 3
    }

    def attrs
      ap '-------------------'
      ap payload_type
      ap '-------------------'
      return deleted_attrs if record.nil?

      case payload_type
      when 'current_association', 'primary_payload', 'previous_association'
        decrypted_attrs
      when 'update_payload'
        decrypted_update_attrs
        # when 'destroy_payload'
        #   destroy_payload_attrs
      end
    end

    def payload_encryption_key
      @payload_encryption_key ||= Loggable::EncryptionKey.for_record(record)&.key
    end

    private

    def deleted_attrs
      encrypted_attrs.transform_values! { '*** DELETED ***' }
    end

    def decrypted_update_attrs
      encrypted_attrs['changes'].map do |change|
        decrypted_from_to_attr(change)
      end
    end

    # def destroy_payload_attrs
    #   '*** DELETED ***'
    # end

    def decrypted_from_to_attr(change)
      change.to_h do |key, value|
        from = decrypt_attr(value['from'])
        to = decrypt_attr(value['to'])
        [key, { from:, to: }]
      end
    end

    def decrypted_attrs
      encrypted_attrs.each do |key, value|
        encrypted_attrs[key] = decrypt_attr(value)
      end
    end

    def decrypt_attr(value)
      Loggable::Encryption.decrypt(value, payload_encryption_key)
    end
  end
end
