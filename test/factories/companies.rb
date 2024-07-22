# frozen_string_literal: true

FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
  end
end
