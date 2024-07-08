# frozen_string_literal: true

require 'test_helper'

class UpdatePayloadsBuilderTest < ActiveSupport::TestCase
  class NoRelations < UpdatePayloadsBuilderTest
    setup do
      @user = create(:user, age: 55)

      @user.update(first_name: 'John', age: 60)

      @payloads = []
    end

    test 'it prepares update payload' do
      result = ::LoggableActivity::Services::UpdatePayloadsBuilder.new(@user, @payloads).build

      assert_equal LoggableActivity::Payload, @payloads.last.class
      assert_equal({ 'changes' => [{ 'age' =>  { 'from' => 55, 'to' => 60 } }] }, @payloads.last.public_attrs)
    end
  end
end
