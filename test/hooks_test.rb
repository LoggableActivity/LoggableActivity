# frozen_string_literal: true

require 'test_helper'

class HooksTest < ActiveSupport::TestCase
  setup do
    Thread.current[:current_actor] = @current_user = create(:user, user_type: 'admin')
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

    test 'it logs create with has_one and belongs to relations' do
      activity = LoggableActivity::Activity.last
      assert_equal 3, activity.payloads_attrs.count
      assert_equal @user, activity.record
      assert_equal 'user.create', activity.action
      assert_equal @current_user, activity.actor

      relations = activity.payloads_attrs.collect { |payload_attrs| payload_attrs[:relation] }
      assert_equal %w[self has_one belongs_to], relations

      user_payload_attrs = activity.payloads_attrs.select { |payload_attrs| payload_attrs[:relation] == 'self' }.first
      assert_equal @user.first_name, user_payload_attrs.dig(:attrs, :first_name)

      profile_attrs = activity.payloads_attrs.select { |payload_attrs| payload_attrs[:relation] == 'has_one' }.first
      assert_equal @user.profile.phone_number, profile_attrs.dig(:attrs, :phone_number)

      company_attrs = activity.payloads_attrs.select { |payload_attrs| payload_attrs[:relation] == 'belongs_to' }.first
      assert_equal @user.company.name, company_attrs.dig(:attrs, :name)
    end

    test 'it logs update with has_one and belongs_to relations' do
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
      user = create(:user, :with_profile, company: nil)
      user.destroy

      activity = LoggableActivity::Activity.last

      assert_equal 2, activity.payloads_attrs.count
      assert_equal 'has_one', activity.payloads_attrs.last[:relation]
      assert_equal 'Profile', activity.payloads_attrs.last[:record_type]
      assert_equal 'user.destroy', activity.action
      assert_equal I18n.t('loggable_activity.activity.deleted'), activity.payloads_attrs.first.dig(:attrs, :first_name)
      assert_equal @current_user, LoggableActivity::Activity.last.actor
    end

    test 'it logs show, with belongs_to relation' do
      user = create(:user)
      user.log(:show, actor: @current_user)

      activity = LoggableActivity::Activity.last

      assert_equal 2, activity.payloads_attrs.count
      assert_equal 'user.show', activity.action
      assert_equal @current_user, LoggableActivity::Activity.last.actor
    end
  end

  class HasManyRelations < HooksTest
  end

  class CustomAttribures < HooksTest
    setup do
      @user = create(:user)
      @params = {
        display_name: 'Checkout Order - #123',
        order: {
          route: '/orders/123',
          order_number: '123',
          items: [
            { name: 'item1', units: 1, price: 10 },
            { name: 'item2', units: 3, price: 1 }
          ]
        }
      }
    end
    test 'it logs custom attributes' do
      @user.log(
        :checkout_order,
        actor: @current_user,
        params: @params
      )
      activity = LoggableActivity::Activity.last
      assert activity
      assert_equal activity[:action], 'user.checkout_order'
      assert_equal 1, LoggableActivity::Activity.last.payloads.count
      payload_attrs = LoggableActivity::Activity.last.payloads_attrs.first
      assert_equal @params[:display_name], payload_attrs[:attrs][:display_name]
      assert_equal @params.dig(:order, :items).length, payload_attrs[:attrs][:order][:items].length
    end
  end

  class DontLogAfterCreate < HooksTest
    test 'it does not log after create' do
      user = create(:user)
      activity = LoggableActivity::Activity.last
      user.log(:show, actor: @current_user)
      assert_equal activity, LoggableActivity::Activity.last
      # assert_nil LoggableActivity::Activity.last
    end
  end
end
