# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LoggableActivity::Payload, type: :model do
  describe '#Payload' do
    before do
      stub_const('Rails', double('Rails'))
      allow(Rails).to receive_message_chain(:application, :config, :loggable_activity).and_return(OpenStruct.new(actor_display_name: :full_name, current_user_model_name: 'User'))
      current_user = MockUser.create(name: 'John Doe', email: 'john.doe@example.com')
      Thread.current[:current_user] = current_user
    end

    it 'returns attrs' do
      MockModel.create(
        first_name: 'John',
        last_name: 'Doe',
        age: 55,
        model_type: 'MockModel'
      )
      payload = LoggableActivity::Activity.last.payloads.first
      expect(payload.attrs).to eq({ 'first_name' => 'John', 'last_name' => 'Doe', 'age' => '55' })
    end
  end
end
