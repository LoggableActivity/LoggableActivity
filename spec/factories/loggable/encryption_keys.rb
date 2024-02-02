# frozen_string_literal: true

FactoryBot.define do
  factory :loggable_encryption_key, class: 'Loggable::EncryptionKey' do
    record_type { 'Demo::Addredd' }
    record_id { SecureRandom.uuid }
    parrent_key_id { SecureRandom.uuid }
    key { SecureRandom.hex(16) }
  end
end
