# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'user@example.com' }
    password { 'password123' }
    password_confirmation { 'password123' }
  end
end
