# frozen_string_literal: true

FactoryBot.define do
  factory :loggable_payload, class: 'Loggable::Payload' do
    owner { '' }
    encrypted_attrs { '' }
    activity { nil }
  end
end
