# frozen_string_literal: true

# This is a module for encryption and decryption of attributes
require 'openssl'
require 'base64'

module LoggableActivity
  # This module is used to encrypt and decrypt attributes
  module Encryption
    # Encrypts the given data using the given encryption key
    #
    # Example:
    #   ::LoggableActivity::Encryption.encrypt('my secret data', 'my secret key')
    #
    # Returns:
    #   "SOME_ENCRYPTED_STRING"
    #
    def self.encrypt(data, secret_key)
      return nil if secret_key.nil? || data.nil?

      encryption_key = Base64.decode64(secret_key)
      unless encryption_key.bytesize == 32
        raise EncryptionError, "Encryption failed: Invalid encoded_key length #{encryption_key.bytesize}"
      end

      cipher = OpenSSL::Cipher.new('AES-256-CBC').encrypt
      cipher.key = encryption_key
      cipher.iv = iv = cipher.random_iv

      encrypted = cipher.update(data.to_s) + cipher.final
      # Combine IV with encrypted data, encode with Base64 for storage/transmission
      Base64.encode64(iv + encrypted)
    rescue OpenSSL::Cipher::CipherError => e
      raise EncryptionError, "Encryption failed: #{e.message}"
    end

    # Decrypts the given data using the given encryption key
    #
    # Example:
    #   ::LoggableActivity::Encryption.decrypt('SOME_ENCRYPTED_DATA', 'SECRET_KEY')
    #
    # Returns:
    #   "my secret data"
    #
    def self.decrypt(data, secret_key)
      case data
      when Hash
        decrypt_hash(data, secret_key)
      when Array
        decrypt_array(data, secret_key)
      else
        decrypt_data(data, secret_key)
      end
    end

    # Decrypts a hash's values using the given encryption key
    def self.decrypt_hash(data, secret_key)
      data
        .transform_values { |value| decrypt(value, secret_key) }
        .transform_keys(&:to_sym)
    end

    # Decrypts an array's values using the given encryption key
    def self.decrypt_array(data, secret_key)
      data.map { |value| decrypt(value, secret_key) }
    end

    # Checks if a value is blank
    def self.blank?(value)
      value.respond_to?(:empty?) ? value.empty? : !value
    end

    # Decrypts individual data using the given encryption key
    def self.decrypt_data(data, secret_key)
      return I18n.t('loggable_activity.activity.deleted') if secret_key.nil?
      return '' if data.blank?

      encryption_key = Base64.decode64(secret_key)
      unless encryption_key.bytesize == 32
        raise EncryptionError, "Decryption failed: Invalid encoded_key length: #{encryption_key.bytesize}"
      end

      cipher = OpenSSL::Cipher.new('AES-256-CBC').decrypt
      cipher.key = encryption_key
      raise EncryptionError, 'Decryption failed: Invalid data length' unless data.bytesize > cipher.iv_len

      raw_data = Base64.decode64(data)
      cipher.iv = raw_data[0...cipher.iv_len] # Extract IV from the beginning of raw_data
      decrypted_data = cipher.update(raw_data[cipher.iv_len..]) + cipher.final

      decrypted_data.force_encoding('UTF-8')
    rescue OpenSSL::Cipher::CipherError => e
      Rails.logger.error "CipherError Decryption failed: #{e.message}"
      I18n.t('loggable_activity.decryption.failed')
    rescue EncryptionError => e
      Rails.logger.error "EncryptionError: #{e.message}"
      I18n.t('loggable_activity.decryption.failed')
    rescue ArgumentError => e
      Rails.logger.error "ArgumentError Decryption failed: #{e.message}"
      I18n.t('loggable_activity.decryption.failed')
    end
  end
end
