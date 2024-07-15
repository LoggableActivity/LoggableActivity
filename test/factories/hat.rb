# frozen_string_literal: true

FactoryBot.define do
  factory :hat do
    color { Faker::Color.color_name }
  end
end
