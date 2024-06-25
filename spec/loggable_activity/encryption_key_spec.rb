# frozen_string_literal: true

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

  context 'when task_for_sanitization is true' do
    before do
      allow(LoggableActivity::Configuration).to receive(:task_for_sanitization) { true }
    end
    describe '#mark_as_deleted' do
      let(:encryption_key) { described_class.create_encryption_key('User', 1) }

      it 'marks the encryption key as deleted' do
        encryption_key.mark_as_deleted!
        expect(encryption_key.reload.deleted?).to be_truthy
      end
    end

    describe '#deleted' do
      let(:encryption_key) { described_class.create_encryption_key('User', 1) }

      it 'delete the secret key' do
        encryption_key.delete
        expect(encryption_key.secret_key).to eq(nil)
      end
    end

    describe '#restore' do
      let(:encryption_key) { described_class.create_encryption_key('User', 1) }

      it 'restore the key' do
        encryption_key.mark_as_deleted!
        encryption_key.restore!

        expect(encryption_key.reload.deleted?).to be_falsey
      end

      it 'does not restore the key if it was deleted more than a month ago' do
        encryption_key.mark_as_deleted!
        encryption_key.update(delete_at: 2.months.ago)
        encryption_key.restore!

        expect(encryption_key.reload.deleted?).to be_truthy
      end
    end
  end

  context 'when task_for_sanitization is false' do
    before do
      allow(LoggableActivity::Configuration).to receive(:task_for_sanitization) { false }
    end
    describe '#mark_as_deleted' do
      let(:encryption_key) { described_class.create_encryption_key('User', 1) }

      it 'deletes the secret_key' do
        encryption_key.mark_as_deleted!
        expect(encryption_key.secret_key).to eq(nil)
      end

      it 'can not restore the key' do
        encryption_key.mark_as_deleted!
        encryption_key.restore!
        expect(encryption_key.reload.deleted?).to be_truthy
        expect(encryption_key.secret_key).to eq(nil)
        # expect(encryption_key.delete_at).to eq(nil)
      end
    end

  end

  describe '.create_encryption_key' do
    it 'creates a new encryption key' do
      expect do
        described_class.create_encryption_key('User', 1)
      end.to change(described_class, :count).by(1)
    end

    it 'new encrytion keys is not deleted' do
      encryption_key = described_class.create_encryption_key('User', 1)
      expect(encryption_key.deleted?).to be_falsey
    end
  end

  describe '.random_key' do
    it 'generates a random encryption key' do
      key = described_class.random_key
      expect(key).to be_a(String)
    end
  end
end
