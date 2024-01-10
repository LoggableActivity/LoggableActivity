# frozen_string_literal: true

require 'openssl'
require 'base64'

module Loggable
  module Encryption
    def self.encrypt(data, owner)
      key = Loggable::EncryptionKey.for_owner(owner)
      cipher = OpenSSL::Cipher.new('AES-128-CBC').encrypt
      cipher.key = Digest::SHA1.hexdigest(key)[0..15]
      encrypted = cipher.update(data) + cipher.final
      Base64.encode64(encrypted)
    end

    def self.decrypt_for(data, owner)
      key = Loggable::EncryptionKey.for_owner(owner)
      decrypt(data, key)
    end

    def self.decrypt(data, key)
      # return 'na' if key.blank?
      cipher = OpenSSL::Cipher.new('AES-128-CBC').decrypt
      cipher.key = Digest::SHA1.hexdigest(key)[0..15]
      decrypted_data = Base64.decode64(data)
      decrypted_output = cipher.update(decrypted_data) + cipher.final
      raise 'Decryption failed: Invalid UTF-8 output' unless decrypted_output.valid_encoding?

      decrypted_output.force_encoding('UTF-8')
    rescue OpenSSL::Cipher::CipherError
      # Handle decryption errors
    end
  end
end
