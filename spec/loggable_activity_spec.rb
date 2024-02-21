# frozen_string_literal: true

require 'loggable_activity'

RSpec.describe LoggableActivity do
  it 'has a version number' do
    expect(LoggableActivity::VERSION).not_to be nil
  end
end
