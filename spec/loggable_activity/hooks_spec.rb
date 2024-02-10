# frozen_string_literal: true

require 'loggable_activity_helper'

RSpec.describe LoggableActivity::Hooks do
  it 'includes LoggableActivity::PayloadsBuilder' do
    expect(LoggableActivity::Hooks).to include(LoggableActivity::PayloadsBuilder)
    expect(LoggableActivity::Hooks).to include(LoggableActivity::UpdatePayloadsBuilder)
  end
end
