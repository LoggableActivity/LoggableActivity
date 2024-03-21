# frozen_string_literal: true

require 'spec_helper'
require 'json-schema'
require 'json'

RSpec.describe LoggableActivity::Activity do
  let(:activity_schema) { JSON.parse(File.read('spec/support/schemas/create_activity_schema.json')) }
  describe 'create an activity' do
    before do
      @current_user = MockUser.create(name: 'Charly Chaplin', email: 'charly.chaplin@example.com')
      Thread.current[:current_user] = @current_user
    end

    it 'with no relations' do
      count = LoggableActivity::Payload.all.count
      MockModel.create(
        first_name: 'Eva',
        last_name: 'Peron',
        age: 55,
        model_type: 'MockModel'
      )
      activity_json = LoggableActivity::Activity.last.attrs.to_json
      expect(JSON::Validator.validate!(activity_schema, activity_json)).to be true

      expect(LoggableActivity::Payload.all.count).to eq(count + 1)
      payload = LoggableActivity::Activity.last.payloads.last
      expect(payload.related_to_activity_as).to eq('primary_payload')
    end

    it 'with a belongs_to relations' do
      mock_parent = MockParent.create(name: 'John', age: 55)
      MockChild.create(name: 'Jane', age: 5, mock_parent:)

      attrs = LoggableActivity::Activity.last.attrs

      activity_json = attrs.to_json
      expect(JSON::Validator.validate!(activity_schema, activity_json)).to be true

      payloads = attrs[:payloads]
      expect(payloads.count).to eq(2)

      primary_payload = payloads.find { |p| p[:related_to_activity_as] == 'primary_payload' }
      expect(primary_payload[:record_type]).to eq('MockChild')
      expect(primary_payload[:route]).to eq('show_child')

      belongs_to_payload = payloads.find { |p| p[:related_to_activity_as] == 'belongs_to_payload' }
      expect(belongs_to_payload[:record_type]).to eq('MockParent')
      expect(belongs_to_payload[:route]).to eq('show_parent')
    end

    it 'with has_many relations' do
      mock_children = [
        MockChild.create(name: 'Jane', age: 5),
        MockChild.create(name: 'Bob', age: 10)
      ]
      MockParent.create(name: 'John the Parent', age: 55, mock_children:)

      attrs = LoggableActivity::Activity.last.attrs
      activity_json = attrs.to_json
      expect(JSON::Validator.validate!(activity_schema, activity_json)).to be true
      payloads = attrs[:payloads]
      expect(payloads.count).to eq(3)

      primary_payload = payloads.find { |p| p[:related_to_activity_as] == 'primary_payload' }
      expect(primary_payload[:record_type]).to eq('MockParent')
      expect(primary_payload[:route]).to eq('show_parent')

      has_many_payloads = attrs[:payloads].select { |payload| payload[:related_to_activity_as] == 'has_many_payload' }
      expect(has_many_payloads.count).to eq(2)

      expect(has_many_payloads.all? { |payload| payload[:record_type] == 'MockChild' }).to be true
    end

    it 'with belongs_to relations where one are data_owner' do
      patient = MockUser.create(name: 'Patient A', email: 'patient@example.com')
      doctor = MockUser.create(name: 'Doctor A', email: 'doctor@example.com')

      mock_journal = MockJournal.create(
        title: 'Journal',
        body: 'Secret about the patient',
        patient:,
        doctor:
      )

      LoggableActivity::Activity.last.attrs
      mock_journal_key = LoggableActivity::EncryptionKey.for_record(mock_journal)
      LoggableActivity::EncryptionKey.for_record(patient)

      data_owner = LoggableActivity::DataOwner.find_by(record: patient)
      expect(data_owner.encryption_key_id).to eq(mock_journal_key.id)

      data_owner = LoggableActivity::DataOwner.find_by(record: doctor)
      expect(data_owner).to be_nil
    end

    it 'with has_one relations' do
      MockParent.create(name: 'John', age: 55, mock_job_attributes: { name: 'Driver', wage: 4000 })

      attrs = LoggableActivity::Activity.last.attrs
      expect(attrs[:action]).to eq('mockparent.create')
      expect(attrs[:payloads].count).to eq(2)

      activity_json = attrs.to_json
      expect(JSON::Validator.validate!(activity_schema, activity_json)).to be true
      has_many_payloads = attrs[:payloads].select { |payload| payload[:related_to_activity_as] == 'has_one_payload' }
      expect(has_many_payloads.count).to eq(1)
    end
  end
end
