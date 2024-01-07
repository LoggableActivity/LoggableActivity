# frozen_string_literal: true

FactoryBot.define do
  factory :demo_product, class: 'Demo::Product' do
    name { 'MyString' }
    part_number { 'MyString' }
    price { '9.99' }
  end
end
