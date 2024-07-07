# frozen_string_literal: true

require 'application_system_test_case'

class HatsTest < ApplicationSystemTestCase
  setup do
    @hat = hats(:one)
  end

  test 'visiting the index' do
    visit hats_url
    assert_selector 'h1', text: 'Hats'
  end

  test 'should create hat' do
    visit hats_url
    click_on 'New hat'

    fill_in 'Color', with: @hat.color
    fill_in 'User', with: @hat.user_id
    click_on 'Create Hat'

    assert_text 'Hat was successfully created'
    click_on 'Back'
  end

  test 'should update Hat' do
    visit hat_url(@hat)
    click_on 'Edit this hat', match: :first

    fill_in 'Color', with: @hat.color
    fill_in 'User', with: @hat.user_id
    click_on 'Update Hat'

    assert_text 'Hat was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Hat' do
    visit hat_url(@hat)
    click_on 'Destroy this hat', match: :first

    assert_text 'Hat was successfully destroyed'
  end
end
