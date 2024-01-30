# frozen_string_literal: true
# This the key used to unlock the data for one payload.
# When deleted only the encryption_key field is deleted.

module Loggable
  class EncryptionKey < ApplicationRecord
    require 'securerandom'
    belongs_to :record, polymorphic: true, optional: true

    def self.for_record_by_type_and_id(record_type, record_id)
      enctyption_key = find_by(record_type:, record_id:)

      return enctyption_key if enctyption_key

      create(record_type:, record_id:, encryption_key: random_key)
    end

    def self.encryption_key_for_record(record)
      encryption_key = find_by(record:)
      return encryption_key if encryption_key

      create(record:, encryption_key: random_key)
    end

    def self.delete_key_for_record(record)
      encryption_key = find_by(record:)
      encryption_key&.update(encryption_key: nil)
    end

    def self.random_key
      SecureRandom.hex(16)
    end

    def self.delete_key_by_id(id)
      return unless id

      encryption_key = find_by(id:)
      encryption_key&.update(encryption_key: nil)
    end
  end
end
