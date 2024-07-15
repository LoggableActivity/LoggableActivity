# frozen_string_literal: true

require_relative '../../../test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should log sign_up' do
    User.create(
      first_name: 'John',
      last_name: 'Doe',
      email: 'john@example.com',
      password: 'password',
      age: 37,
      user_type: 'customer'
    )
    assert_equal LoggableActivity::Activity.last.action, 'user.sign_up'
  end
end
