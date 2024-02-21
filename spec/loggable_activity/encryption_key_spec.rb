# frozen_string_literal: true

# spec/models/loggable_activity/encryption_key_spec.rb
require 'spec_helper'

RSpec.describe LoggableActivity::EncryptionKey, type: :model do
  describe '.for_record_by_type_and_id' do
    let(:record_type) { 'User' }
    let(:record_id) { 1 }

    context 'when encryption key does not exist' do
      let(:new_record_id) { described_class.last&.id.to_i + 1 }
      it 'creates a new encryption key' do
        expect do
          described_class.for_record_by_type_and_id(record_type, new_record_id)
        end.to change(described_class, :count).by(1)
      end
    end

    context 'when encryption key exists' do
      before do
        described_class.create_encryption_key(record_type, record_id)
      end

      it 'returns the existing encryption key' do
        expect(described_class.for_record_by_type_and_id(record_type, record_id)).to be_present
      end
    end
  end

  describe '#mark_as_deleted' do
    let(:encryption_key) { described_class.create_encryption_key('User', 1) }

    it 'marks the encryption key as deleted' do
      encryption_key.mark_as_deleted
      expect(encryption_key.reload.key).to be_nil
    end
  end

  describe '.create_encryption_key' do
    it 'creates a new encryption key' do
      expect do
        described_class.create_encryption_key('User', 1)
      end.to change(described_class, :count).by(1)
    end
  end

  describe '.random_key' do
    it 'generates a random encryption key' do
      key = described_class.random_key
      expect(key).to be_a(String)
      # You may add more expectations here depending on how you want to validate the key
    end
  end
end
