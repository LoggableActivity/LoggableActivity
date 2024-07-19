# frozen_string_literal: true

require_relative '../../../test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should log sign_up' do
    user = User.new(
      first_name: 'John',
      last_name: 'Doe',
      email: 'john@example.com',
      password: 'password',
      age: 37,
      user_type: 'customer'
    )
    user.disable_hooks!
    user.save!
    user.log(:sign_up, actor: user)

    assert_equal LoggableActivity::Activity.last.action, 'user.sign_up'
  end
end
