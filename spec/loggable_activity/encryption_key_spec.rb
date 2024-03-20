# frozen_string_literal: true

require 'awesome_print'

# spec/models/loggable_activity/encryption_key_spec.rb
require 'spec_helper'

RSpec.describe ::LoggableActivity::EncryptionKey, type: :model do
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

    # context 'with a parent key' do
    #   it 'creates a new encryption key with a parent key' do
    #     parrent_key = described_class.for_record_by_type_and_id('User', 1)
    #     key = described_class.for_record_by_type_and_id('User', 2, parrent_key)
    #     expect(key.parent_key_id).to eq(parrent_key.id)
    #   end
    # end
  end

  describe '#mark_as_deleted' do
    let(:encryption_key) { described_class.create_encryption_key('User', 1) }

    it 'marks the encryption key as deleted' do
      encryption_key.mark_as_deleted!
      expect(encryption_key.reload.secret_key).to be_nil
    end

    # it 'marks parrent_key as deleted' do
    #   parent_key = described_class.for_record_by_type_and_id('User', 2, encryption_key)
    #   parent_key.mark_as_deleted!
    #   expect(encryption_key.deleted?).to be_truthy
    # end
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
