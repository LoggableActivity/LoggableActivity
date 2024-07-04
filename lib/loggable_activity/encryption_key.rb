# frozen_string_literal: true

require 'active_record'

module LoggableActivity
  # This class represents the encryption key used to unlock the data for one payload.
  # When deleted, only the encryption_key field is deleted.
  class EncryptionKey < ActiveRecord::Base
    self.table_name = 'loggable_activity_encryption_keys'

    # Associations
    belongs_to :record, polymorphic: true, optional: true
    # belongs_to :payload, class_name: '::LoggableActivity::Payload', optional: true
    # belongs_to :parent_key, class_name: '::LoggableActivity::EncryptionKey', optional: true,
    # foreign_key: 'parent_key_id'

    # Prepare the record for deletion
    def mark_as_deleted!
      LoggableActivity::Configuration.task_for_sanitization ? update(delete_at: DateTime.now + 1.month) : delete
    end

    # check if the encryption key is deleted or it is about to be deleted
    def deleted?
      secret_key.nil? || delete_at.present?
    end

    # Delete the encryption key by updating the key to nil.
    def delete
      update(secret_key: nil, delete_at: nil)
    end

    # Restores the encryption key by updating the delete_at field to nil.
    def restore!
      update(delete_at: nil) if delete_at && DateTime.now < delete_at
    end

    # Returns an encryption key for a record by its type and ID, optionally using a parent key.
    #
    #  @param record_type [String] The type of the record.
    #  @param record_id [Integer] The ID of the record.
    #  @param parent_key [::LoggableActivity::EncryptionKey, nil] The parent encryption key, if any.
    #  @return [::LoggableActivity::EncryptionKey] The encryption key for the record.
    #
    # Example:
    #  ::LoggableActivity::EncryptionKey.for_record_by_type_and_id('User', 1)
    #
    # Returns:
    #  {
    #    :id => 39,
    #    :parent_key_id => 38,
    #    :key => "a8f4774e7f42eb253045a4db7de7b79e",
    #    :record_type => "User",
    #    :record_id => 1
    #  }
    #
    def self.for_record_by_type_and_id(record_type, record_id)
      encryption_key = find_by(record_type:, record_id:)
      return encryption_key if encryption_key

      create_encryption_key(record_type, record_id)
    end

    # Returns an encryption key for a record, optionally using a parent key.
    #
    #  @param record [ActiveRecord::Base] The record for which to get the encryption key.
    #  @param parent_key [::LoggableActivity::EncryptionKey, nil] The parent encryption key, if any.
    #  @return [::LoggableActivity::EncryptionKey] The encryption key for the record.
    #
    # Example:
    #  user = User.find(1)
    #  ::LoggableActivity::EncryptionKey.for_record(user)
    #
    # Returns:
    #  {
    #    :id => 39,
    #    :parent_key_id => 38,
    #    :key => "a8f4774e7f42eb253045a4db7de7b79e",
    #    :record_type => "User",
    #    :record_id => 1
    #  }
    #
    def self.for_record(record)
      return nil if record.nil?

      encryption_key = find_by(record:)
      return encryption_key if encryption_key

      create_encryption_key(record.class.name, record.id)
    end

    # Creates an encryption key for a record, optionally using a parent key.
    #
    #  @param record_type [String] The type of the record.
    #  @param record_id [Integer] The ID of the record.
    #  @param parent_key [::LoggableActivity::EncryptionKey, nil] The parent encryption key, if any.
    #  @return [::LoggableActivity::EncryptionKey] The created encryption key.
    #
    # Example:
    #  ::LoggableActivity::EncryptionKey.create_encryption_key('User', 1)
    #
    # Returns:
    #  {
    #    :id => 39,
    #    :parent_key_id => 38,
    #    :key => "a8f4774e7f42eb253045a4db7de7b79e",
    #    :record_type => "User",
    #    :record_id => 1
    #  }
    #
    def self.create_encryption_key(record_type, record_id)
      create(record_type:, record_id:, secret_key: random_key)
    end

    # Generates a random encryption key.
    #
    #  @return [String] The generated encryption key.
    #
    # Example:
    #  ::LoggableActivity::EncryptionKey.random_key
    #
    # Returns:
    #  "a8f4774e7f42eb253045a4db7de7b79e"
    #
    def self.random_key
      # Generate 32 random bytes (256 bits) directly
      encryption_key = SecureRandom.random_bytes(32)
      # Encode the key in Base64 to ensure it's in a transferable format
      Base64.encode64(encryption_key).strip
    end
  end
end
