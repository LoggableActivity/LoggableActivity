# frozen_string_literal: true

# spec/factories/loggable_activities.rb
FactoryBot.define do
  factory :activity, class: LoggableActivity::Activity do
    action { 'user.show' }
    actor factory: :user # Assuming you have a :user factory for the actor
    record factory: :user # Replace :some_record with an appropriate factory for the record
  end
end
