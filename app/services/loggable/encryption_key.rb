# frozen_string_literal: true

module Loggable
  class EncryptionKey < ApplicationRecord
    require 'securerandom'
    belongs_to :owner, polymorphic: true, optional: true

    def self.for_owner_by_type_and_id(type, id)
      enctyption_key = find_by(owner_type: type, owner_id: id)

      return enctyption_key.encryption_key if enctyption_key

      ap generated_key = generate_encryption_key
      create(owner_type: type, owner_id: id, encryption_key: generated_key)
      generated_key
    end

    def self.for_owner(owner)
      encryption_key = find_by(owner:)
      return encryption_key.encryption_key if encryption_key

      generated_key = generate_encryption_key
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
