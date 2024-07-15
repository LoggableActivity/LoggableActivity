# frozen_string_literal: true

require_relative '../../../test_helper'

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
  end

  test 'should get index' do
    get loggable_activity.activities_url
    assert_response :success
    assert_includes response.body, ' <h1>Activities</h1>'
  end
end
