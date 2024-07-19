# frozen_string_literal: true

require_relative '../../../test_helper'

class HatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    Thread.current[:current_actor] = @user
  end

  test 'should create hat' do
    assert_difference('Hat.count') do
      post create_hat_user_url(@user), params: { hat: { color: 'red' } }
    end

    assert_equal LoggableActivity::Activity.all.last.action, 'hat.create'
  end
end
