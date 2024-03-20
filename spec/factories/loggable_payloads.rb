# frozen_string_literal: true

# spec/factories/loggable_payloads.rb
FactoryBot.define do
  factory :payload, class: '::LoggableActivity::Payload' do
    association :record, factory: :user # Replace with an appropriate record factory
    encrypted_attrs { { some_key: 'Some Encrypted Value' }.to_json }
    payload_type { 0 }
    # association :activity, factory: :activity

    # trait :with_different_payload_type do
    # payload_type { 1 } # Or any other payload type you might have
    # end
  end
end
