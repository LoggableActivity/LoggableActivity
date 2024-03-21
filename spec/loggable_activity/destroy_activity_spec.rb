# frozen_string_literal: true

require 'spec_helper'
require 'json-schema'
require 'json'

RSpec.describe LoggableActivity::Activity do
  let(:activity_schema) { JSON.parse(File.read('spec/support/schemas/create_activity_schema.json')) }
  describe 'destroy an activity' do
    before do
      @current_user = MockUser.create(name: 'Charly Chaplin', email: 'charly.chaplin@example.com')
      Thread.current[:current_user] = @current_user
    end

    it 'with no relations' do
      LoggableActivity::Payload.all.count
      mock_model =
        MockModel.create(
          first_name: 'Eva',
          last_name: 'Peron',
          age: 55,
          model_type: 'MockModel'
        )

      mock_model.destroy
      attrs = LoggableActivity::Activity.last.attrs
      attrs_json = attrs.to_json
      expect(JSON::Validator.validate!(activity_schema, attrs_json)).to be true

      payloads = attrs[:payloads]
      expect(payloads.count).to eq(1)

      primary_destroy_payload = payloads.find { |p| p[:related_to_activity_as] == 'primary_destroy_payload' }
      expect(primary_destroy_payload[:record_type]).to eq('MockModel')
      expect(primary_destroy_payload[:record_id]).to eq(nil)
    end

    it 'with a belongs_to relations' do
      mock_parent = MockParent.create(name: 'John', age: 55)
      mock_child = MockChild.create(name: 'Jane', age: 5, mock_parent:)
      mock_child.destroy

      attrs = LoggableActivity::Activity.last.attrs

      payloads = attrs[:payloads]
      expect(payloads.count).to eq(1)

      primary_destroy_payload = payloads.find { |p| p[:related_to_activity_as] == 'primary_destroy_payload' }
      expect(primary_destroy_payload[:record_type]).to eq('MockChild')
      expect(primary_destroy_payload[:route]).to eq('')
      expect(primary_destroy_payload[:record_id]).to eq(nil)
    end

    it 'with a has_one relation' do
      mock_parent =
        MockParent.create(
          name: 'John',
          age: 55,
          mock_job: MockJob.new(
            name: 'Doctor',
            wage: 100_000
          )
        )
      mock_parent.destroy
      attrs = LoggableActivity::Activity.last.attrs

      payloads = attrs[:payloads]
      expect(payloads.count).to eq(2)

      primary_destroy_payload = payloads.find { |p| p[:related_to_activity_as] == 'primary_destroy_payload' }
      expect(primary_destroy_payload[:record_type]).to eq('MockParent')
      expect(primary_destroy_payload[:route]).to eq('')
      expect(primary_destroy_payload[:record_id]).to eq(nil)
    end

    it 'with has_many relations' do
      mock_children = [
        MockChild.create(name: 'Jane', age: 5),
        MockChild.create(name: 'Bob', age: 10)
      ]
      mock_parent = MockParent.create(name: 'John the Parent', age: 55, mock_children:)
      mock_parent.destroy
      attrs = LoggableActivity::Activity.last.attrs

      payloads = attrs[:payloads]
      expect(payloads.count).to eq(3)
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

    it 'belongs_to that are data_owner delete the encryption key ' do
      patient = MockUser.create(name: 'Patient A', email: 'patient@example.com')
      doctor = MockUser.create(name: 'Doctor A', email: 'doctor@example.com')

      mock_journal = MockJournal.create(
        title: 'Journal',
        body: 'Secret about the patient',
        patient:,
        doctor:
      )

      patient.destroy

      encryption_key = LoggableActivity::EncryptionKey.for_record(mock_journal)
      expect(encryption_key.secret_key).to be_nil
    end

    #     attrs = ::LoggableActivity::Activity.last.attrs
    #     activity_json = attrs.to_json
    #     expect(JSON::Validator.validate!(activity_schema, activity_json)).to be true
    #     payloads = attrs[:payloads]
    #     expect(payloads.count).to eq(3)

    #     primary_payload = payloads.find { |p| p[:related_to_activity_as] == 'primary_payload' }
    #     expect(primary_payload[:record_type]).to eq('MockParent')
    #     expect(primary_payload[:route]).to eq('show_parent')

    #     has_many_payloads = attrs[:payloads].select { |payload| payload[:related_to_activity_as] == 'has_many_payload' }
    #     expect(has_many_payloads.count).to eq(2)

    #     expect(has_many_payloads.all? { |payload| payload[:record_type] == 'MockChild' }).to be true
    #   end

    #   it 'with has_one relations' do
    #     MockParent.create(name: 'John', age: 55, mock_job_attributes: { name: 'Driver', wage: 4000 })

    #     attrs = ::LoggableActivity::Activity.last.attrs
    #     expect(attrs[:action]).to eq('mockparent.create')
    #     expect(attrs[:payloads].count).to eq(2)

    #     activity_json = attrs.to_json
    #     expect(JSON::Validator.validate!(activity_schema, activity_json)).to be true
    #     has_many_payloads = attrs[:payloads].select { |payload| payload[:related_to_activity_as] == 'has_one_payload' }
    #     expect(has_many_payloads.count).to eq(1)
    #   end
  end
end
