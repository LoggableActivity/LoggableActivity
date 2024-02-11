# frozen_string_literal: true

# This the key used to unlock the data for one payload.
# When deleted only the encryption_key field is deleted.

module LoggableActivity
  class EncryptionKey < ActiveRecord::Base
    self.table_name = 'loggable_encryption_keys'
    require 'securerandom'
    belongs_to :record, polymorphic: true, optional: true
    belongs_to :parrent_key, class_name: 'LoggableActivity::EncryptionKey', optional: true,
                             foreign_key: 'parrent_key_id'

    def mark_as_deleted
      update(key: nil)
      parrent_key.mark_as_deleted if parrent_key.present?
    end

    def self.for_record_by_type_and_id(record_type, record_id, parrent_key = nil)
      enctyption_key = find_by(record_type:, record_id:)

      return enctyption_key if enctyption_key

      create_encryption_key(record_type, record_id, parrent_key)
    end

    def self.for_record(record, parrent_key = nil)
      encryption_key = find_by(record:)
      return encryption_key if encryption_key

      create_encryption_key(record.class.name, record.id, parrent_key)
    end

    def self.create_encryption_key(record_type, record_id, parrent_key = nil)
      if parrent_key
        create(record_type:, record_id:, key: random_key, parrent_key_id: parrent_key.id)
      else
        create(record_type:, record_id:, key: random_key)
      end
    end

    def self.random_key
      SecureRandom.hex(16)
    end
  end
end
