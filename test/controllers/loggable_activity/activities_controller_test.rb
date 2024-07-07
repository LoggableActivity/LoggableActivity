# frozen_string_literal: true

require 'test_helper'

module LoggableActivity
  class ActivitiesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test 'should get index' do
      get activities_url
      assert_response :success
    end

    test 'should get show' do
      get activities_url(1)
      assert_response :success
    end
  end
end
