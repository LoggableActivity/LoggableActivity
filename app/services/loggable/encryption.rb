# frozen_string_literal: true

require 'openssl'
require 'base64'

module Loggable
  module Encryption
    def self.encrypt(data, key)
      cipher = OpenSSL::Cipher.new('AES-128-CBC').encrypt
      cipher.key = Digest::SHA1.hexdigest(key)[0..15]
      encrypted = cipher.update(data) + cipher.final
      Base64.encode64(encrypted)
    end

    def self.decrypt(data, key)
      cipher = OpenSSL::Cipher.new('AES-128-CBC').decrypt
      cipher.key = Digest::SHA1.hexdigest(key)[0..15]
      decrypted_data = Base64.decode64(data)
      cipher.update(decrypted_data) + cipher.final
    rescue OpenSSL::Cipher::CipherError
      # Handle decryption errors
    end
  end
end
