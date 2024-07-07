# frozen_string_literal: true

require_relative '../../../test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
  end

  test 'should get index' do
    get users_url
    assert_response :success
  end

  test 'should get new' do
    get new_user_url
    assert_response :success
  end

  test 'should create user' do
    assert_difference('User.count') do
      post users_url,
           params: { user: { age: @user.age + 1, email: "new-#{@user.email}", first_name: "new-#{@user.first_name}",
                             last_name: @user.last_name, user_type: @user.user_type } }
    end

    assert_redirected_to user_url(User.last)
  end

  test 'should show user' do
    get user_url(@user)
    assert_response :success
  end

  test 'should get edit' do
    get edit_user_url(@user)
    assert_response :success
  end

  test 'should update user' do
    patch user_url(@user),
          params: {
            user: {
              age: @user.age,
              email: @user.email,
              first_name: @user.first_name,
              last_name: @user.last_name,
              user_type: @user.user_type
            }
          }
    assert_redirected_to user_url(@user)
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
