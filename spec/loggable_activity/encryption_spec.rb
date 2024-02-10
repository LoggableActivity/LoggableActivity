# frozen_string_literal: true

require 'loggable_activity'
require 'securerandom'

RSpec.describe LoggableActivity::Encryption do
  context 'when encrypting data' do
    it 'raises an error if the key is nil' do
      data_to_encrypt = 'data to be encrypted'
      expect do
        LoggableActivity::Encryption.encrypt(data_to_encrypt,
                                             nil)
      end.to raise_error(LoggableActivity::EncryptionError, 'Encryption key can not be nil')
    end

    it 'raises an error if the key is nil' do
      data_to_encrypt = 'data to be encrypted'
      invalid_encryption_key = SecureRandom.hex(164)
      expect do
        LoggableActivity::Encryption.encrypt(data_to_encrypt,
                                             invalid_encryption_key)
      end.to raise_error(LoggableActivity::EncryptionError, 'Encryption failed: Invalid encryption key length')
    end

    it 'returns nil if the data is nil' do
      data_to_encrypt = nil
      valid_encryption_key = SecureRandom.hex(16)
      expect(LoggableActivity::Encryption.encrypt(data_to_encrypt, valid_encryption_key)).to be_nil
    end

    it 'returns encrypted data with a valid key' do
      data_to_encrypt = 'data to be encrypted'
      valid_encryption_key = SecureRandom.hex(16)
      expect(LoggableActivity::Encryption.encrypt(data_to_encrypt, valid_encryption_key)).to_not eql('data_to_encrypt')
    end
  end

  context 'when decrypting data' do
    it 'raises an error if the key is invalid' do
      data = 'super secret data'
      invalid_encryption_key = 'invalid key'
      valid_encryption_key = SecureRandom.hex(16)
      encrypted_data = LoggableActivity::Encryption.encrypt(data, valid_encryption_key)
      expect do
        LoggableActivity::Encryption.decrypt(encrypted_data,
                                             invalid_encryption_key)
      end.to raise_error(LoggableActivity::EncryptionError, 'bad decrypt')
    end

    it 'returns decrypted data with a valid key' do
      data = 'super secret data'
      valid_encryption_key = SecureRandom.hex(16)
      encrypted_data = LoggableActivity::Encryption.encrypt(data, valid_encryption_key)
      expect(LoggableActivity::Encryption.decrypt(encrypted_data, valid_encryption_key)).to eql(data)
    end
  end
end
