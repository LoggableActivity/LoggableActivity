# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LoggableActivity::Configuration do
  describe '.load_config_file' do
    context 'when the file exists' do
      # let(:config_file_path) { Rails.root.join('config', 'loggable_activity.yml') }
      let(:config_file_path) { 'spec/test_files/loggable_activity.yml' }

      it 'loads the configuration from the file' do
        # Action
        described_class.load_config_file(config_file_path)

        # Assertion
        expect(described_class.for_class('current_user_model_name')).to eq('MockUser')
      end
    end

    context 'when the file does not exist' do
      let(:invalid_path) { 'non_existent_file.yml' }

      it 'raises an error' do
        expect { described_class.load_config_file(invalid_path) }.to raise_error(LoggableActivity::ConfigurationError)
      end
    end
  end

  describe '.for_class' do
    before do
      config_data = {
        'current_user_model_name' => 'MockUser',
        'fetch_current_user_name_from' => 'full_name',
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

  describe '.fetch_current_user_name_from' do
    before do
      config_data = {
        'current_user_model_name' => 'MockUser',
        'fetch_current_user_name_from' => 'full_name'

      }
      allow(YAML).to receive(:load_file).and_return(config_data)
      described_class.load_config_file('dummy_path')
    end

    it 'returns the fetch_current_user_name_from' do
      expect(described_class.fetch_current_user_name_from).to eq('full_name')
    end
  end

  describe '.current_user_model_name' do
    before do
      config_data = {
        'current_user_model_name' => 'MockUser',
        'fetch_current_user_name_from' => 'full_name'

      }
      allow(YAML).to receive(:load_file).and_return(config_data)
      described_class.load_config_file('dummy_path')
    end

    it 'returns the current_user_model_name' do
      expect(described_class.current_user_model_name).to eq('MockUser')
    end
  end

  describe 'invalid configuration' do
    it 'raises ConfigurationError when fetch_current_user_name_from is missing' do
      config_file_path = 'spec/test_files/model_name_only.yml'
      expect { described_class.load_config_file(config_file_path) }.to raise_error(LoggableActivity::ConfigurationError)
    end

    it 'raises ConfigurationError when current_user_model_name is missing' do
      config_file_path = 'spec/test_files/fetch_name_only.yml'
      expect { described_class.load_config_file(config_file_path) }.to raise_error(LoggableActivity::ConfigurationError)
    end
  end
end
