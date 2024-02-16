# frozen_string_literal: true

# This is a module for encryption and decryption of attributes
require 'openssl'
require 'base64'

module LoggableActivity
  # This error is raised when encryption or decryption fails
  class EncryptionError < StandardError
  end

  # This module is used to encrypt and decrypt attributes
  module Encryption
    # Encrypts the given data using the given encryption key
    #
    # Example:
    #   LoggableActivity::Encryption.encrypt('my secret data', 'my secret key')
    #
    # Returns:
    #   "SOME_ENCRYPTED_STRING"
    #
    def self.encrypt(data, encryption_key)
      return nil if data.nil?
      return nil if encryption_key.nil?
      raise EncryptionError, 'Encryption failed: Invalid encryption key length' unless encryption_key.bytesize == 32

      cipher = OpenSSL::Cipher.new('AES-128-CBC').encrypt
      cipher.key = Digest::SHA1.hexdigest(encryption_key)[0..15]
      encrypted = cipher.update(data.to_s) + cipher.final
      Base64.encode64(encrypted)
    rescue OpenSSL::Cipher::CipherError => e
      raise EncryptionError, "Encryption failed: #{e.message} ***"
    end

    # Decrypts the given data using the given encryption key
    #
    # Example:
    #   LoggableActivity::Encryption.decrypt('SOME_ENCRYPTED_STRING', 'SECRET_KEY')
    #
    # Returns:
    #   "my secret data"
    #
    def self.decrypt(data, encryption_key)
      return '' if data.nil?
      return I18n.t('loggable.activity.deleted') if encryption_key.nil?

      cipher = OpenSSL::Cipher.new('AES-128-CBC').decrypt
      cipher.key = Digest::SHA1.hexdigest(encryption_key)[0..15]
      decrypted_data = Base64.decode64(data)
      decrypted_output = cipher.update(decrypted_data) + cipher.final
      raise 'Decryption failed: Invalid UTF-8 output' unless decrypted_output.valid_encoding?

      decrypted_output.force_encoding('UTF-8')
    rescue OpenSSL::Cipher::CipherError => e
      raise EncryptionError, e.message
    end

    def self.blank?(value)
      value.respond_to?(:empty?) ? value.empty? : !value
    end
  end
end
