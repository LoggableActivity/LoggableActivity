# frozen_string_literal: true

RSpec.describe LoggableActivity do
  it 'has a version number' do
    expect(LoggableActivity::VERSION).not_to be nil
  end

  it 'Cannary test' do
    expect(true).to eq(true)
  end
end
