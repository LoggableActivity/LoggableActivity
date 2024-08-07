# frozen_string_literal: true

require 'test_helper'

class EndpointCallerTest < ActiveSupport::TestCase
  test 'it calls endpoint' do
    #   stub_request(:get, 'http://example.com/users/1').to_return(status: 200, body: {
    #     id: 1,
    #     first
    # }
    Thread.current[:current_actor] = user = create(:user)
    user.update(first_name: "#{user.first_name}_Updated")
    activity = LoggableActivity::Activity.last
    # ap activity.payloads_attrs
    LoggableActivity::Services::EndpointCaller.new(
      actor_display_name: activity[:actor_display_name],
      action: activity[:action],
      record: user,
      actor: user,
      payloads: activity.payloads
    ).call
  end
end
