# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    age { Faker::Number.between(from: 18, to: 80) }
    user_type { %w[customer admin].sample }
    created_at { Faker::Time.between(from: 2.years.ago, to: Time.current, format: :default) }
    updated_at { Faker::Time.between(from: 1.year.ago, to: Time.current, format: :default) }

    trait :with_profile do
      profile_attributes do
        {
          bio: Faker::Lorem.paragraph,
          profile_picture_url: Faker::Avatar.image,
          location: Faker::Address.city,
          date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 80),
          phone_number: Faker::PhoneNumber.phone_number
        }
      end
    end
  end
end
