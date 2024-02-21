# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LoggableActivity::Encryption do
  let(:key) { Base64.encode64(SecureRandom.random_bytes(32)) }
  let(:data) { 'my secret data' }

  describe '.encrypt' do
    context 'when data and key are present' do
      it 'encrypts the data' do
        encrypted_data = described_class.encrypt(data, key)
        expect(encrypted_data).not_to be_nil
        expect(encrypted_data).not_to eq(data)
      end
    end

    context 'when data or key is nil' do
      it 'returns nil' do
        expect(described_class.encrypt(nil, key)).to be_nil
        expect(described_class.encrypt(data, nil)).to be_nil
      end
    end
  end

  describe '.decrypt' do
    context 'when encrypted data and key are present' do
      it 'decrypts the data' do
        encrypted_data = described_class.encrypt(data, key)
        expect(described_class.decrypt(encrypted_data, key)).to eq(data)
      end
    end

    context 'when encrypted data or key is nil' do
      it 'returns empty string' do
        expect(described_class.decrypt(nil, key)).to eq('')
        expect(described_class.decrypt(data, nil)).to eq('')
      end
    end
  end

  describe '.blank?' do
    it 'returns true for nil' do
      expect(described_class.blank?(nil)).to be true
    end

    it 'returns true for empty string' do
      expect(described_class.blank?('')).to be true
    end

    it 'returns false for non-empty string' do
      expect(described_class.blank?('data')).to be false
    end
  end
end
