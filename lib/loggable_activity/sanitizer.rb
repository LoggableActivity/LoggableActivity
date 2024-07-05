# frozen_string_literal: true

module LoggableActivity
  # This module is responsible for sanitizing activities.
  # When an encryption keys deleted_at field is set, the key is deleted.
  module Sanitizer
    def self.run
      ::LoggableActivity::EncryptionKey.where('delete_at < ?', DateTime.now).find_in_batches do |batch|
        batch.each(&:delete)
      end
    end
  end
end
