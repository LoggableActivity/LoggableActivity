# frozen_string_literal: true

require 'test_helper'

module LoggableActivity
  class MetadataTest < ActiveSupport::TestCase
    setup do
      Thread.current[:current_actor] = @current_user = create(:user, user_type: 'admin')
    end

    test 'It create metadata' do
      user = User.create(first_name: 'Bob', last_name: 'Doe', email: 'bob@example.com', password: 'password')
      metadata = LoggableActivity::Metadata.last

      assert_equal user, metadata.record
      assert_equal @current_user, metadata.actor
      assert_equal "#{@current_user.first_name} #{@current_user.last_name}", metadata.actor_display_name
    end

    test 'It only creates the same metadata once' do
      user = User.create(first_name: 'Bob', last_name: 'Doe', email: 'bob@example.com', password: 'password')
      LoggableActivity::Activity.last.update(created_at: 7.seconds.ago)
      user.update(first_name: 'Robert')
      LoggableActivity::Activity.last.update(created_at: 7.seconds.ago)
      user.log(:show)
      user.update(first_name: 'Robert')
      LoggableActivity::Activity.last.update(created_at: 7.seconds.ago)
      user.log(:show)

      assert_equal 3, LoggableActivity::Metadata.where(record: user).count
    end

    test 'It delete metadata on delete' do
      user = User.create(first_name: 'Jane', last_name: 'Doe', email: 'bob@example.com', password: 'password')
      user.delete

      assert_empty LoggableActivity::Metadata.where(record: user)
    end

    test 'It delete metadata on destroy' do
      user = User.create(first_name: 'Jane', last_name: 'Doe', email: 'bob@example.com', password: 'password',
                         user_type: 'person')
      user.destroy

      assert_empty LoggableActivity::Metadata.where(record: user)
    end
  end
end
