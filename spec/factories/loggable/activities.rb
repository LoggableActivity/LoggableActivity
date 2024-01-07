# frozen_string_literal: true

FactoryBot.define do
  factory :loggable_activity, class: 'Loggable::Activity' do
    action { 'some_model.some_action' }
    association :actor, factory: :user
  end
end
