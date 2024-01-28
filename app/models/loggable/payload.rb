# frozen_string_literal: true

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
    }

    def attrs
      case payload_type
      when 'primary_payload'
        decrypted_primary_payload
      when 'update_payload'
        decrypted_update_payload
      when 'current_association'
        decrypted_primary_payload
      when 'previous_association'
        decrypted_primary_payload
      end
    end

    private 

    def decrypted_primary_payload
      decrypted_attrs 
    end

    # def decrypted_update_payload
    #   ap decrypted_changes
    #   decrypted_changes
    # end

    private

    def decrypted_update_payload
      encrypted_attrs['changes'].map do |change|
        decrypted_from_to_attr(change)
      end
    end

    def decrypted_from_to_attr(change)
      encryption_key = Loggable::EncryptionKey.for_record(record) 
      change.map do |key, value|
        from = decrypt_attr(value['from'], encryption_key)
        to = decrypt_attr(value['to'], encryption_key)
        [key, { from: from, to: to }]
      end.to_h
    end
    

    def decrypted_attrs
      key = Loggable::EncryptionKey.for_record(record) 
      encrypted_attrs.each do |key, value|
        encrypted_attrs[key] = decrypt_attr(value, key)
      end
    end

    def decrypt_attr(value, key)
      Loggable::Encryption.decrypt(value, key)
    end
  end
end
