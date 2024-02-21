# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LoggableActivity::PayloadsBuilder do
  describe 'build_payloads' do
    before do
      stub_const('Rails', double('Rails'))
      allow(Rails).to receive_message_chain(:application, :config, :loggable_activity).and_return(OpenStruct.new(actor_display_name: :full_name, current_user_model_name: 'User'))
      current_user = MockUser.create(name: 'John Doe', email: 'john.doe@example.com')
      Thread.current[:current_user] = current_user
    end

    it 'builds a primary payload' do
      count = LoggableActivity::Payload.all.count
      MockModel.create(
        first_name: 'John',
        last_name: 'Doe',
        age: 55,
        model_type: 'MockModel'
      )
      expect(LoggableActivity::Payload.all.count).to eq(count + 1)
      payload = LoggableActivity::Activity.last.payloads.last
      expect(payload.payload_type).to eq('primary_payload')
    end

    it 'builds a payload with belongs_to relations' do
      mock_parent = MockParent.create(name: 'John', age: 55)
      count = LoggableActivity::Payload.all.count

      MockChild.create(name: 'Jane', age: 5, mock_parent:)
      expect(LoggableActivity::Payload.all.count).to eq(count + 2)

      payloads = LoggableActivity::Activity.last.payloads
      current_association = payloads.find { |payload| payload.payload_type == 'current_association' }
      expect(current_association.record).to eq(mock_parent)
    end
  end
end
