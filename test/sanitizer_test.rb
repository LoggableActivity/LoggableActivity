# frozen_string_literal: true

require 'test_helper'

class LoggableActivitySanitizerTest < ActiveSupport::TestCase
  def setup
    @encryption_key = LoggableActivity::EncryptionKey.create_encryption_key('User', 1)
  end

  test 'encryption keys marked for deletion before time to delete the key' do
    LoggableActivity.stubs(:task_for_sanitization).returns(true)
    @encryption_key.mark_as_deleted!

    LoggableActivity::Sanitizer.run
    @encryption_key.reload

    assert @encryption_key.deleted?
    refute_nil @encryption_key.secret_key
    refute_nil @encryption_key.delete_at
  end

  test 'encryption keys marked for deletion after time to delete the key permanently' do
    LoggableActivity.stubs(:task_for_sanitization).returns(true)
    @encryption_key.mark_as_deleted!
    @encryption_key.update(delete_at: 1.day.ago)

    LoggableActivity::Sanitizer.run
    @encryption_key.reload

    assert @encryption_key.deleted?
    assert_nil @encryption_key.secret_key
    assert_nil @encryption_key.delete_at
  end
end
