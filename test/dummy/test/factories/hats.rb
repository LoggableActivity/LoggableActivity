# frozen_string_literal: true

FactoryBot.define do
  factory :hat do
    color { 'MyString' }
    user { nil }
  end
end
