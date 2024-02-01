# frozen_string_literal: true

FactoryBot.define do
  factory :demo_journal, class: 'Demo::Journal' do
    patient { nil }
    doctor { nil }
    title { 'MyString' }
    body { 'MyText' }
    state { 'MyString' }
  end
end
