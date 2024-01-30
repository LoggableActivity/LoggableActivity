# frozen_string_literal: true

require 'openssl'
require 'base64'

module Loggable
  module Encryption
    def self.encrypt(data, encryption_key)
      cipher = OpenSSL::Cipher.new('AES-128-CBC').encrypt
      cipher.key = Digest::SHA1.hexdigest(encryption_key)[0..15]
      encrypted = cipher.update(data.to_s) + cipher.final
      Base64.encode64(encrypted)
    rescue OpenSSL::Cipher::CipherError => e
      "*** Encryption failed: #{e.message} ***"
    end

    def self.decrypt(data, encryption_key)
      return I18n.t('loggable.activity.deleted') if data.blank? || encryption_key.blank?

      cipher = OpenSSL::Cipher.new('AES-128-CBC').decrypt
      cipher.key = Digest::SHA1.hexdigest(encryption_key)[0..15]
      decrypted_data = Base64.decode64(data)
      decrypted_output = cipher.update(decrypted_data) + cipher.final
      raise 'Decryption failed: Invalid UTF-8 output' unless decrypted_output.valid_encoding?

      decrypted_output.force_encoding('UTF-8')
    rescue OpenSSL::Cipher::CipherError => e
      Rails.logger.debug "*** Decryption failed: #{e.message} ***"
      nil
    end
  end
end
