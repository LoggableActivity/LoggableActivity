# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: MockUser do
    name { 'John Doe' }
    email { 'john@example.com' }
    sequence(:id) { |n| n }
  end
end
