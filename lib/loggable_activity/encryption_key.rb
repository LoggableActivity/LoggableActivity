# frozen_string_literal: true


module LoggableActivity
  # This class represents the encryption key used to unlock the data for one payload.
  # When deleted, only the encryption_key field is deleted.
  class EncryptionKey < ActiveRecord::Base
    self.table_name = 'loggable_encryption_keys'

    # Associations
    belongs_to :record, polymorphic: true, optional: true
    belongs_to :parrent_key, class_name: 'LoggableActivity::EncryptionKey', optional: true,
                             foreign_key: 'parrent_key_id'

    # Marks the encryption key as deleted by updating the key to nil.
    def mark_as_deleted
      update(key: nil)
      parrent_key.mark_as_deleted if parrent_key.present?
    end

    # Returns an encryption key for a record by its type and ID, optionally using a parent key.
    #
    #  @param record_type [String] The type of the record.
    #  @param record_id [Integer] The ID of the record.
    #  @param parent_key [LoggableActivity::EncryptionKey, nil] The parent encryption key, if any.
    #  @return [LoggableActivity::EncryptionKey] The encryption key for the record.
    #
    # Example:
    #  LoggableActivity::EncryptionKey.for_record_by_type_and_id('User', 1)
    # 
    # Returns:
    #  {
    #    :id => 39,
    #    :parrent_key_id => 38,
    #    :key => "a8f4774e7f42eb253045a4db7de7b79e",
    #    :record_type => "User",
    #    :record_id => 1
    #  }
    #
    def self.for_record_by_type_and_id(record_type, record_id, parent_key = nil)
      encryption_key = find_by(record_type: record_type, record_id: record_id)
      return encryption_key if encryption_key

      create_encryption_key(record_type, record_id, parent_key)
    end

    # Returns an encryption key for a record, optionally using a parent key.
    #
    #  @param record [ActiveRecord::Base] The record for which to get the encryption key.
    #  @param parent_key [LoggableActivity::EncryptionKey, nil] The parent encryption key, if any.
    #  @return [LoggableActivity::EncryptionKey] The encryption key for the record.
    #
    # Example:
    #  user = User.find(1)
    #  LoggableActivity::EncryptionKey.for_record(user)
    #
    # Returns:
    #  {
    #    :id => 39,
    #    :parrent_key_id => 38,
    #    :key => "a8f4774e7f42eb253045a4db7de7b79e",
    #    :record_type => "User",
    #    :record_id => 1
    #  }
    #
    def self.for_record(record, parent_key = nil)
      encryption_key = find_by(record: record)
      return encryption_key if encryption_key

      create_encryption_key(record.class.name, record.id, parent_key)
    end

    # Creates an encryption key for a record, optionally using a parent key.
    #
    #  @param record_type [String] The type of the record.
    #  @param record_id [Integer] The ID of the record.
    #  @param parent_key [LoggableActivity::EncryptionKey, nil] The parent encryption key, if any.
    #  @return [LoggableActivity::EncryptionKey] The created encryption key.
    #
    # Example:
    #  LoggableActivity::EncryptionKey.create_encryption_key('User', 1)
    #
    # Returns:
    #  {
    #    :id => 39,
    #    :parrent_key_id => 38,
    #    :key => "a8f4774e7f42eb253045a4db7de7b79e",
    #    :record_type => "User",
    #    :record_id => 1
    #  }
    #
    def self.create_encryption_key(record_type, record_id, parent_key = nil)
      if parent_key
        create(record_type: record_type, record_id: record_id, key: random_key, parent_key_id: parent_key.id)
      else
        create(record_type: record_type, record_id: record_id, key: random_key)
      end
    end

    # Generates a random encryption key.
    #
    #  @return [String] The generated encryption key.
    #
    # Example:
    #  LoggableActivity::EncryptionKey.random_key
    #
    # Returns:
    #  "a8f4774e7f42eb253045a4db7de7b79e"
    #
    def self.random_key
      SecureRandom.hex(16)
    end
  end
end
