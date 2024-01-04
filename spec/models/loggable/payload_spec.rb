require 'rails_helper'

RSpec.describe Loggable::Payload, type: :model do
  describe 'validations' do
    let(:activity) { build(:loggable_activity) } 

    it 'is valid with valid attributes and a valid activity' do
      attrs = { key: "value"}.to_json 
      payload = Loggable::Payload.new(owner: SecureRandom.uuid, attrs: attrs , activity: activity)
      expect(payload).to be_valid
    end

    it 'is invalid without an owner' do
      attrs = { key: "value"}.to_json 
      payload = Loggable::Payload.new(attrs: attrs , activity: activity)
      payload.valid?
      expect(payload.errors[:owner]).to include("can't be blank")
    end

    it 'is invalid without attrs' do
      payload = Loggable::Payload.new(owner: SecureRandom.uuid, activity: activity)
      payload.valid?
      expect(payload.errors[:attrs]).to include("can't be blank")
    end

    it 'is invalid without an associated activity' do
      attrs = { key: "value"}.to_json 
      payload = Loggable::Payload.new(owner: SecureRandom.uuid, attrs: attrs)
      payload.valid?
      expect(payload.errors[:activity]).to include("must exist")
    end
  end

  describe 'associations' do
    it 'belongs to an activity' do
      payload = Loggable::Payload.reflect_on_association(:activity)
      expect(payload.macro).to eq(:belongs_to)
    end
  end
end
