# frozen_string_literal: true

require 'spec_helper'
require 'rspec/rails'

RSpec.describe LoggableActivity::Hooks, type: :model do
  describe 'activities' do
    before do
      stub_const('Rails', double('Rails'))
      allow(Rails).to receive_message_chain(:application, :config, :loggable_activity).and_return(Hash.new(actor_display_name: :full_name, current_user_model_name: 'User'))
      current_user = MockUser.create(name: 'John Doe', email: 'john.doe@example.com')
      Thread.current[:current_user] = current_user
    end

    it 'it log when a model is created' do
      count = LoggableActivity::Activity.all.count

      MockModel.create(
        first_name: 'John',
        last_name: 'Doe',
        age: 55,
        model_type: 'MockModel'
      )
      expect(LoggableActivity::Activity.all.count).to eq(count + 1)
      # loggable_model.update(first_name: 'Jane')
      # loggable
      # association = CommentableModel.reflect_on_association(:comments)
      # expect(association.macro).to eq(:has_many)
      # expect(association.options[:as]).to eq(:commentable)
      # expect(association.options[:dependent]).to eq(:destroy)
    end
  end
end
