
# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LoggableActivity::Sanitizer do
  let(:encryption_key) { LoggableActivity::EncryptionKey.create_encryption_key('User', 1) }
  describe '.run' do
    context 'encryption keys marked for deletion' do
      before do
        allow(LoggableActivity::Configuration).to receive(:task_for_sanitization) { true }
        encryption_key.mark_as_deleted!
      end

      it 'before time to delete the key' do
        LoggableActivity::Sanitizer.run
        encryption_key.reload
        expect(encryption_key.deleted?).to be_truthy
        expect(encryption_key.secret_key).not_to eq(nil)
        expect(encryption_key.delete_at).not_to eq(nil)
      end
      
      it 'after time to delete the key permanently' do
        encryption_key.update(delete_at: 1.day.ago)
        LoggableActivity::Sanitizer.run
        encryption_key.reload
        expect(encryption_key.deleted?).to be_truthy
        expect(encryption_key.secret_key).to eq(nil)
        expect(encryption_key.delete_at).to eq(nil)
      end
    end
  end
end