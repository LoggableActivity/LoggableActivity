# frozen_string_literal: true

FactoryBot.define do
  factory :encryption_key do
    owner_id { 'MyString' }
    encryption_key { 'MyString' }
  end
end
