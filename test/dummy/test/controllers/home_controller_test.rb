# frozen_string_literal: true

require_relative '../../../test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get home_index_url

    assert_response :success
  end
end
