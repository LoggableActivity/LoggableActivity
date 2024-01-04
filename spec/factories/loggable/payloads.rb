FactoryBot.define do
  factory :loggable_payload, class: 'Loggable::Payload' do
    owner { "" }
    attrs { "" }
    activity { nil }
  end
end
