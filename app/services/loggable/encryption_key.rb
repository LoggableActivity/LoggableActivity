# frozen_string_literal: true

module Loggable
  class EncryptionKey < ApplicationRecord
    require 'securerandom'
    belongs_to :record, polymorphic: true, optional: true

    def self.for_record_by_type_and_id(type, id)
      enctyption_key = find_by(record_type: type, record_id: id)

      return enctyption_key.encryption_key if enctyption_key

      generated_key = generate_encryption_key
      create(record_type: type, record_id: id, encryption_key: generated_key)
      generated_key
    end

    def self.for_record(record)
      encryption_key = find_by(record:)
      return encryption_key.encryption_key if encryption_key

      generated_key = generate_encryption_key
      create(record:, encryption_key: generated_key)
      generated_key
    end

    def self.delete_key_for_record(record)
      encryption_key = find_by(record:)
      encryption_key&.update(encryption_key: nil)
    end

    def self.generate_encryption_key
      SecureRandom.hex(16)
    end
  end
end
