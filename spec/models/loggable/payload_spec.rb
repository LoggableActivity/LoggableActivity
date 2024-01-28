# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Loggable::Payload, type: :model do
  describe 'validations' do
    let(:activity) { build(:loggable_activity) }

    it 'is valid with valid attributes and a valid activity' do
      record = FactoryBot.create(:user)
      encrypted_attrs = { key: 'value' }.to_json
      payload = Loggable::Payload.new(record:, encrypted_attrs:, activity:)
      expect(payload).to be_valid
    end

    # it 'is invalid without an record' do
    #   attrs = { key: "value"}.to_json
    #   payload = Loggable::Payload.new(attrs: attrs , activity: activity)
    #   payload.valid?
    #   expect(payload.errors[:record]).to include("can't be blank")
    # end

    it 'is invalid without attrs' do
      record = FactoryBot.create(:user)
      payload = Loggable::Payload.new(record:, activity:)
      payload.valid?
      expect(payload.errors[:encrypted_attrs]).to include("can't be blank")
    end

    it 'is invalid without an associated activity' do
      encrypted_attrs = { key: 'value' }.to_json
      record = FactoryBot.create(:user)
      payload = Loggable::Payload.new(record:, encrypted_attrs:)
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
