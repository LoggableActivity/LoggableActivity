# frozen_string_literal: true

require 'test_helper'

module LoggableActivity
  class EncryptionTest < ActiveSupport::TestCase
    def setup
      @key = Base64.encode64(SecureRandom.random_bytes(32))
      @data = 'my secret data'
    end

    test 'encrypt encrypts the data when data and key are present' do
      encrypted_data = LoggableActivity::Encryption.encrypt(@data, @key)
      assert_not_nil encrypted_data
      assert_not_equal @data, encrypted_data
    end

    test 'encrypt returns nil when data or key is nil' do
      assert_nil LoggableActivity::Encryption.encrypt(nil, @key)
      assert_nil LoggableActivity::Encryption.encrypt(@data, nil)
    end

    test 'decrypt decrypts the data when encrypted data and key are present' do
      encrypted_data = LoggableActivity::Encryption.encrypt(@data, @key)
      assert_equal @data, LoggableActivity::Encryption.decrypt(encrypted_data, @key)
    end

    test 'decrypt returns empty string when encrypted data or key is nil' do
      assert_equal '', LoggableActivity::Encryption.decrypt(nil, @key)
      assert_equal I18n.t('loggable_activity.activity.deleted'), LoggableActivity::Encryption.decrypt(@data, nil)
    end

    test 'blank? returns true for nil' do
      assert LoggableActivity::Encryption.blank?(nil)
    end

    test 'blank? returns true for empty string' do
      assert LoggableActivity::Encryption.blank?('')
    end

    test 'blank? returns false for non-empty string' do
      assert_not LoggableActivity::Encryption.blank?('data')
    end

    test 'EncryptionError is a subclass of StandardError' do
      assert LoggableActivity::EncryptionError < StandardError
    end

    test 'throws an error when encryption fails' do
      assert_raises(LoggableActivity::EncryptionError, 'Encryption failed: Invalid encoded_key length 7') do
        LoggableActivity::Encryption.encrypt('Some data to encrypt', 'some_bad_key')
      end
    end

    test 'throws an error when decryption fails' do
      encryption_key = LoggableActivity::EncryptionKey.create_encryption_key('User', 1)
      assert_equal '*** DECRYPTION FAILED ***', LoggableActivity::Encryption.decrypt('Some data to decrypt', "#{encryption_key.secret_key}extra")
    end
  end
end
