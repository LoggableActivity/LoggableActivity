# frozen_string_literal: true

FactoryBot.define do
  factory :demo_address, class: 'Demo::Address' do
    street { 'MyString' }
    city { 'MyString' }
    country { 'MyString' }
    postal_code { 'MyString' }
  end
end
