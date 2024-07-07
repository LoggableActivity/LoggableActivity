# frozen_string_literal: true

require 'test_helper'

class HatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hat = hats(:one)
  end

  test 'should get index' do
    get hats_url
    assert_response :success
  end

  test 'should get new' do
    get new_hat_url
    assert_response :success
  end

  test 'should create hat' do
    assert_difference('Hat.count') do
      post hats_url, params: { hat: { color: @hat.color, user_id: @hat.user_id } }
    end

    assert_redirected_to hat_url(Hat.last)
  end

  test 'should show hat' do
    get hat_url(@hat)
    assert_response :success
  end

  test 'should get edit' do
    get edit_hat_url(@hat)
    assert_response :success
  end

  test 'should update hat' do
    patch hat_url(@hat), params: { hat: { color: @hat.color, user_id: @hat.user_id } }
    assert_redirected_to hat_url(@hat)
  end

  test 'should destroy hat' do
    assert_difference('Hat.count', -1) do
      delete hat_url(@hat)
    end

    assert_redirected_to hats_url
  end
end
