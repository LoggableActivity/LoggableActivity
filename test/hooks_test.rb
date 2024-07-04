# frozen_string_literal: true

require 'test_helper'

class HooksTest < ActiveSupport::TestCase
  setup do
    Thread.current[:current_user] = @current_user = create(:user, user_type: 'admin')
  end

  class NoRelations < HooksTest
    test 'it logs create' do
      user = create(:user)

      activity = LoggableActivity::Activity.last

      assert_equal user, activity.record
      assert_equal 'user.create', activity.action
      assert_equal @current_user, LoggableActivity::Activity.last.actor
      assert_equal activity.payloads_attrs.first[:relation], 'self'
      assert_equal user.first_name, activity.payloads_attrs.first.dig(:attrs, :first_name)
    end

    test 'it logs update' do
      first_name_from = @current_user.first_name
      first_name_to = "#{first_name_from}_Updated"
      @current_user.update(first_name: first_name_to)
      activity = LoggableActivity::Activity.last

      assert_equal @current_user, activity.record
      assert_equal 'user.update', activity.action
      assert_equal @current_user, activity.actor

      assert_equal first_name_from, activity.payloads_attrs.first[:attrs].first.dig(:first_name, :from)
      assert_equal first_name_to, activity.payloads_attrs.first[:attrs].first.dig(:first_name, :to)
    end

    test 'it logs destroy' do
      user = create(:user)
      user.destroy
      activity = LoggableActivity::Activity.last
      assert_equal 'user.destroy', activity.action
      assert_equal I18n.t('loggable_activity.activity.deleted'), activity.payloads_attrs.first.dig(:attrs, :first_name)
      assert_equal @current_user, activity.actor
    end

    test 'it logs show' do
      user = create(:user)
      user.log(:show, actor: @current_user)
      activity = LoggableActivity::Activity.last

      assert_equal 'user.show', activity.action
      assert_equal @current_user, activity.actor
    end
  end

  class HasOneRelations < HooksTest
    setup do
      @user = create(:user, :with_profile)
    end

    test 'it logs create with has_one relation' do
      # user = create(:user, :with_profile)

      activity = LoggableActivity::Activity.last
      assert_equal 2, activity.payloads_attrs.count
      assert_equal @user, activity.record
      assert_equal 'user.create', activity.action
      assert_equal @current_user, activity.actor
      assert_equal activity.payloads_attrs.first[:relation], 'self'
      assert_equal activity.payloads_attrs.last[:relation], 'has_one'
      assert_equal @user.first_name, activity.payloads_attrs.first.dig(:attrs, :first_name)
      assert_equal @user.profile.phone_number, activity.payloads_attrs.last.dig(:attrs, :phone_number)
      assert_nil activity.payloads_attrs.last.dig(:attrs, :date_of_birth)
    end

    test 'it logs update with has_one relation' do
      # user = create(:user, :with_profile)
      from_bio = @user.profile.bio
      to_bio = "#{@user.profile.bio}_Updated"

      @user.update(profile_attributes: { bio: to_bio, id: @user.profile.id })

      activity = LoggableActivity::Activity.last
      attrs = activity.payloads_attrs.last[:attrs].first

      assert_equal from_bio, attrs.dig(:bio, :from)
      assert_equal to_bio, attrs.dig(:bio, :to)
      assert_equal @user, activity.record
      assert_equal 'user.update', activity.action
      assert_equal @current_user, activity.actor
    end

    test 'it logs destroy, with has_one relation' do
      user = create(:user, :with_profile)
      user.destroy

      activity = LoggableActivity::Activity.last

      assert_equal 2, activity.payloads_attrs.count
      assert_equal 'has_one', activity.payloads_attrs.last[:relation]
      assert_equal 'Profile', activity.payloads_attrs.last[:record_type]
      assert_equal 'user.destroy', activity.action
      assert_equal I18n.t('loggable_activity.activity.deleted'), activity.payloads_attrs.first.dig(:attrs, :first_name)
      assert_equal @current_user, LoggableActivity::Activity.last.actor
    end

    test 'it logs show, with has_one relation' do
      user = create(:user, :with_profile)
      user.log(:show, actor: @current_user)

      activity = LoggableActivity::Activity.last

      assert_equal 2, activity.payloads_attrs.count
      assert_equal 'user.show', activity.action
      assert_equal @current_user, LoggableActivity::Activity.last.actor
    end
  end

  class HasManyRelations < HooksTest
  end
end
