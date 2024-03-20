# frozen_string_literal: true

require 'spec_helper'
require 'json-schema'
require 'json'
require 'awesome_print'

RSpec.describe ::LoggableActivity::Activity do
  let(:update_activity_schema) { JSON.parse(File.read('spec/support/schemas/update_activity_schema.json')) }
  describe 'update activity' do
    before do
      @current_user = MockUser.create(name: 'Charly Chaplin', email: 'charly.chaplin@example.com')
      Thread.current[:current_user] = @current_user
    end

    it 'with no relations' do
      mock_model = MockModel.create(first_name: 'John', last_name: 'Doe', age: 55, model_type: 'Doctor')

      mock_model.update(first_name: 'Jane', age: 25)
      attrs = ::LoggableActivity::Activity.last.attrs
      attrs_json = attrs.to_json
      expect(JSON::Validator.validate!(update_activity_schema, attrs_json)).to be true
      payloads = attrs[:payloads]
      primary_update_payload = payloads.find { |p| p[:related_to_activity_as] == 'primary_update_payload' }
      expect(primary_update_payload[:attrs].count).to eq(2)
    end

    it 'with belongs to relations' do
      alice = MockParent.create(name: 'Alice', age: 25)
      john = MockParent.create(name: 'John', age: 55)
      mini_john = MockChild.create(name: 'Mini John', age: 5, mock_parent: john)

      mini_john.update(name: 'Mini Alice', mock_parent: alice)

      activity = ::LoggableActivity::Activity.last
      attrs = activity.attrs

      expect(attrs[:action]).to eq('mockchild.update')
      expect(attrs[:actor_display_name]).to eq(@current_user.full_name)

      activity_json = attrs.to_json
      expect(JSON::Validator.validate!(update_activity_schema, activity_json)).to be true

      payloads = attrs[:payloads]
      expect(payloads.count).to eq(3)

      belongs_to_update_payload = payloads.find { |p| p[:related_to_activity_as] == 'belongs_to_update_payload' }
      expect(belongs_to_update_payload[:record_type]).to eq('MockParent')
      expect(belongs_to_update_payload[:route]).to eq('show_parent')
      expect(belongs_to_update_payload[:current_payload]).to be_falsey
      expect(belongs_to_update_payload[:attrs]['name']).to eq(john.name)
    end

    it 'with belongs to relations empty' do
      mini_john = MockChild.create(name: 'Mini John', age: 5)
      mini_john.update(name: 'Mini Alice')

      activity = ::LoggableActivity::Activity.last
      attrs = activity.attrs

      expect(attrs[:action]).to eq('mockchild.update')
      expect(attrs[:actor_display_name]).to eq(@current_user.full_name)

      activity_json = attrs.to_json
      expect(JSON::Validator.validate!(update_activity_schema, activity_json)).to be true

      payloads = attrs[:payloads]
      expect(payloads.count).to eq(1)
    end

    it 'with a has_one_relation' do
      mock_parent = MockParent.create(name: 'John', age: 55, mock_job: MockJob.new(name: 'Doctor', wage: 100_000))
      mock_job = mock_parent.mock_job

      mock_parent.update(age: 56, name: 'Jan', mock_job_attributes: { id: mock_job.id, name: 'Manager' })
      attrs = ::LoggableActivity::Activity.last.attrs
      activity_json = attrs.to_json
      expect(JSON::Validator.validate!(update_activity_schema, activity_json)).to be true

      payloads = attrs[:payloads]
      expect(payloads.count).to eq(2)

      has_one_payload = payloads.find { |p| p[:related_to_activity_as] == 'has_one_update_payload' }

      expect(has_one_payload[:record_type]).to eq('MockJob')
      expect(has_one_payload[:attrs][0]['name']).to eq({ from: 'Doctor', to: 'Manager' })
    end

    it 'with a has_one_update_relation empty' do
      mock_parent = MockParent.create(name: 'John', age: 55, mock_job: MockJob.new(name: 'Doctor', wage: 100_000))
      mock_parent.mock_job
      mock_parent.update(age: 56, name: 'Jan')

      attrs = ::LoggableActivity::Activity.last.attrs

      activity_json = attrs.to_json
      expect(JSON::Validator.validate!(update_activity_schema, activity_json)).to be true

      payloads = attrs[:payloads]
      expect(payloads.count).to eq(1)
    end

    it 'with has_many relation' do
      child_a = MockChild.create(name: 'Update me', age: 5)
      child_b = MockChild.create(name: 'As it is', age: 10)
      parent = MockParent.create(name: 'John the Parent', age: 55, mock_children: [child_a, child_b])

      parent.update(name: 'John the Updated Parent', age: 56, mock_children_attributes: [
                      { id: child_a.id, name: 'Updated', age: 6 },
                      { id: child_b.id },
                      { name: 'Newbee', age: 1 }
                    ])
      attrs = ::LoggableActivity::Activity.last.attrs
      activity_json = attrs.to_json
      expect(JSON::Validator.validate!(update_activity_schema, activity_json)).to be true
      payloads = attrs[:payloads]
      expect(payloads.count).to eq(3)
      has_many_update_payloads = payloads.select { |p| p[:related_to_activity_as] == 'has_many_update_payload' }
      expect(has_many_update_payloads.count).to eq(1)

      has_many_update_payload = has_many_update_payloads.first
      expect(has_many_update_payload[:record_display_name]).to eq('Updated is 6 years old')

      has_many_create_payload = payloads.find { |p| p[:related_to_activity_as] == 'has_many_create_payload' }
      expect(has_many_create_payload[:record_display_name]).to eq('Newbee is 1 years old')
    end

    it 'with has_many relations empty' do
      parent = MockParent.create(name: 'John the Parent', age: 55)

      parent.update(name: 'John the Updated Parent', age: 56)
      attrs = ::LoggableActivity::Activity.last.attrs
      activity_json = attrs.to_json
      expect(JSON::Validator.validate!(update_activity_schema, activity_json)).to be true

      payloads = attrs[:payloads]
      expect(payloads.count).to eq(1)
    end
  end
end
