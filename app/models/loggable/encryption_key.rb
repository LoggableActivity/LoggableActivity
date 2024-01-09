# frozen_string_literal: true

module Loggable
  class EncryptionKey < ApplicationRecord
    require 'securerandom'
    belongs_to :owner, polymorphic: true, optional: true

    def self.for_owner(owner)
      encryption_key = find_by(owner:)
      return encryption_key.encryption_key if encryption_key

      generated_key = generate_encryption_key # Replace with your key generation logic
      create(owner:, encryption_key: generated_key)
      generated_key
    end

    def self.delete_key_for_owner(owner)
      encryption_key = find_by(owner:)
      encryption_key&.update(encryption_key: nil)
    end

    def self.generate_encryption_key
      SecureRandom.hex(16)
    end
  end
end
