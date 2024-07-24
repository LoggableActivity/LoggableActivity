# frozen_string_literal: true

require 'test_helper'

module LoggableActivity
  class EncryptionKeyTest < ActiveSupport::TestCase
    test 'for_record_by_type_and_id creates a new encryption key when it does not exist' do
      record_type = 'User'
      new_record_id = LoggableActivity::EncryptionKey.last&.id.to_i + 1
      assert_difference 'LoggableActivity::EncryptionKey.count', 1 do
        LoggableActivity::EncryptionKey.for_record_by_type_and_id(record_type, new_record_id)
      end
    end

    test 'for_record_by_type_and_id returns the existing encryption key when it exists' do
      record_type = 'User'
      record_id = 1
      LoggableActivity::EncryptionKey.create_encryption_key(record_type, record_id)

      assert_predicate LoggableActivity::EncryptionKey.for_record_by_type_and_id(record_type, record_id), :present?
    end

    test 'mark_as_deleted marks the encryption key as deleted when task_for_sanitization is true' do
      LoggableActivity.stubs(:task_for_sanitization).returns(true)
      encryption_key = LoggableActivity::EncryptionKey.create_encryption_key('User', 1)
      encryption_key.mark_as_deleted!

      assert_predicate encryption_key.reload, :deleted?
    end

    test 'mark_as_deleted deletes the secret key when task_for_sanitization is false' do
      LoggableActivity.stubs(:task_for_sanitization).returns(false)
      encryption_key = LoggableActivity::EncryptionKey.create_encryption_key('User', 1)
      encryption_key.mark_as_deleted!

      assert_nil encryption_key.secret_key
      assert_predicate encryption_key.reload, :deleted?
    end

    test 'restore restores the key when task_for_sanitization is true' do
      LoggableActivity.stubs(:task_for_sanitization).returns(true)
      encryption_key = LoggableActivity::EncryptionKey.create_encryption_key('User', 1)
      encryption_key.mark_as_deleted!
      encryption_key.restore!

      assert_not encryption_key.reload.deleted?
    end

    test 'does not restore the key if it was deleted more than a month ago when task_for_sanitization is true' do
      LoggableActivity.stubs(:task_for_sanitization).returns(true)
      encryption_key = LoggableActivity::EncryptionKey.create_encryption_key('User', 1)
      encryption_key.mark_as_deleted!
      encryption_key.update(delete_at: 2.months.ago)
      encryption_key.restore!

      assert_predicate encryption_key.reload, :deleted?
    end

    test 'create_encryption_key creates a new encryption key' do
      assert_difference 'LoggableActivity::EncryptionKey.count', 1 do
        LoggableActivity::EncryptionKey.create_encryption_key('User', 1)
      end
    end

    test 'new encryption keys are not deleted' do
      encryption_key = LoggableActivity::EncryptionKey.create_encryption_key('User', 1)

      assert_not encryption_key.deleted?
    end

    test 'random_key generates a random encryption key' do
      key = LoggableActivity::EncryptionKey.random_key

      assert_kind_of String, key
    end
  end
end
