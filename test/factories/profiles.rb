# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    user
    bio { Faker::Lorem.paragraph }
    profile_picture_url { Faker::Avatar.image }
    location { Faker::Address.city }
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
    phone_number { Faker::PhoneNumber.phone_number }
  end
end
