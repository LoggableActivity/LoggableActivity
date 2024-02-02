# frozen_string_literal: true

FactoryBot.define do
  factory :demo_user_profile, class: 'Demo::UserProfile' do
    sex { 'MyString' }
    religion { 'MyString' }
    user { nil }
  end
end
