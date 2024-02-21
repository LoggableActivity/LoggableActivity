# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LoggableActivity::Configuration do
  describe '.load_config_file' do
    context 'when the file exists' do
      # let(:config_file_path) { Rails.root.join('config', 'loggable_activity.yml') }
      let(:config_file_path) { 'spec/test_files/loggable_activity_test.yml' }

      it 'loads the configuration from the file' do
        # Action
        described_class.load_config_file(config_file_path)

        # Assertion
        expect(described_class.for_class('some_config')).to eq('some_value')
      end
    end

    context 'when the file does not exist' do
      let(:invalid_path) { 'non_existent_file.yml' }

      it 'raises an error' do
        expect { described_class.load_config_file(invalid_path) }.to raise_error(Errno::ENOENT)
      end
    end
  end

  describe '.for_class' do
    before do
      config_data = {
        'User' => {
          'record_display_name' => 'full_name',
          'loggable_attrs' => %w[first_name last_name],
          'auto_log' => %w[create update destroy]
        }
      }
      allow(YAML).to receive(:load_file).and_return(config_data)
      described_class.load_config_file('dummy_path')
    end

    it 'returns the correct configuration for a given class' do
      expect(described_class.for_class('User')).to eq({
                                                        'record_display_name' => 'full_name',
                                                        'loggable_attrs' => %w[first_name last_name],
                                                        'auto_log' => %w[create update destroy]
                                                      })
    end

    it 'returns nil for a class not in the configuration' do
      expect(described_class.for_class('NonExistentClass')).to be_nil
    end
  end
end
