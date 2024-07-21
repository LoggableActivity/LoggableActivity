# frozen_string_literal: true

FactoryBot.define do
  factory :car do
    color { 'MyString' }
    brand { 'MyString' }
    age { 1 }
  end
end
