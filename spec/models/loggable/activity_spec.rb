require 'rails_helper'

RSpec.describe Loggable::Activity, type: :model do
  describe 'validations' do
    it 'is invalid without who_did_it' do
      activity = Loggable::Activity.new
      expect(activity).not_to be_valid
      expect(activity.errors[:who_did_it]).to include("can't be blank")
    end

    it 'is invalid without at least one payload' do
      activity = Loggable::Activity.new(who_did_it: SecureRandom.uuid)
      expect(activity).not_to be_valid
      expect(activity.errors[:payloads]).to include('must have at least one payload')
    end

    it 'is valid with who_did_it and at least one payload' do
      activity = Loggable::Activity.new(who_did_it: SecureRandom.uuid)
      payload_attrs = {owner: SecureRandom.uuid, attrs: {fo: 'bar'}.to_json , activity: activity}
      activity.payloads.build(payload_attrs)
      expect(activity).to be_valid
    end
  end
end
