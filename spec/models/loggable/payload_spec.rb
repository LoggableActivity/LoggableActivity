# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Loggable::Payload, type: :model do
  describe 'validations' do
    let(:activity) { build(:loggable_activity) }

    it 'is valid with valid attributes and a valid activity' do
      owner = FactoryBot.create(:user)
      attrs = { key: 'value' }.to_json
      payload = Loggable::Payload.new(owner:, attrs:, activity:)
      expect(payload).to be_valid
    end

    # it 'is invalid without an owner' do
    #   attrs = { key: "value"}.to_json
    #   payload = Loggable::Payload.new(attrs: attrs , activity: activity)
    #   payload.valid?
    #   expect(payload.errors[:owner]).to include("can't be blank")
    # end

    it 'is invalid without attrs' do
      owner = FactoryBot.create(:user)
      payload = Loggable::Payload.new(owner:, activity:)
      payload.valid?
      expect(payload.errors[:attrs]).to include("can't be blank")
    end

    it 'is invalid without an associated activity' do
      attrs = { key: 'value' }.to_json
      owner = FactoryBot.create(:user)
      payload = Loggable::Payload.new(owner:, attrs:)
      payload.valid?
      expect(payload.errors[:activity]).to include('must exist')
    end
  end

  describe 'associations' do
    it 'belongs to an activity' do
      payload = Loggable::Payload.reflect_on_association(:activity)
      expect(payload.macro).to eq(:belongs_to)
    end
  end
end
