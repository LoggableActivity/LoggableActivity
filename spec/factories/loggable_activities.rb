# frozen_string_literal: true

# spec/factories/loggable_activities.rb
FactoryBot.define do
  factory :activity, class: LoggableActivity::Activity do
    action { 'user.show' }
    actor factory: :user # Assuming you have a :user factory for the actor
    record factory: :user # Replace :some_record with an appropriate factory for the record

    # after(:build) do |activity|
    #   activity.payloads << build(:payload, activity: activity, encrypted_attrs) # Assuming you have a :payload factory
    # end

    # trait :with_encrypted_display_names do
    #   encrypted_actor_display_name { "Encrypted Actor Name" }
    #   encrypted_record_display_name { "Encrypted Record Name" }
    # end
  end
end
