# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  # Test for valid factory
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  # Test validations
  it 'is valid with a email and password' do
    user = User.new(email: 'test@example.com', password: 'password123', password_confirmation: 'password123')
    expect(user).to be_valid
  end

  it 'is invalid without an email' do
    user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid without a password' do
    user = User.new(password: nil)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  # You can add more tests for other validations here
end
