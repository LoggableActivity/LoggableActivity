# frozen_string_literal: true

# require "test_helper"
require_relative '../../../test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
  end

  test 'should log login' do
    post login_url(email: @user.email, password: 'password')

    assert_equal LoggableActivity::Activity.last.action, 'user.login'
    assert_equal LoggableActivity::Activity.last.actor_type, @user.class.name
    assert_equal LoggableActivity::Activity.last.actor_id, @user.id
  end

  test 'should log logout' do
    post login_url(email: @user.email, password: 'password')

    delete logout_url

    assert_equal LoggableActivity::Activity.last.action, 'user.logout'
  end
end
