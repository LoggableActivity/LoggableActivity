FactoryBot.define do
  factory :user do
    first_name { "MyString" }
    last_name { "MyString" }
    email { "MyString" }
    age { 1 }
    user_type { "MyString" }
  end
end
