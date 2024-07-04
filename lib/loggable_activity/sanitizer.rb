# frozen_string_literal: true

module LoggableActivity
  module Sanitizer
    def self.run
      ::LoggableActivity::EncryptionKey.where('delete_at < ?', DateTime.now).find_in_batches do |batch|
        batch.each(&:delete)
      end
    end
  end
end
