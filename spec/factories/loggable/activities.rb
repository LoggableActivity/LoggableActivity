FactoryBot.define do
  factory :loggable_activity, class: 'Loggable::Activity' do
    key { "MyString" }
    who_did_it { "" }
  end
end
