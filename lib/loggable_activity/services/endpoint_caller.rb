# frozen_string_literal: true

module LoggableActivity
  module Services
    # This class is responsible for calling the loggable activity endpoint.
    class EndpointCaller
      def initialize(actor_display_name:, action:, actor:, record:, payloads:)
        @actor_display_name = actor_display_name
        @action = action
        @actor = actor
        @record = record
        @payloads = payloads
      end

      def call
        # RabbitmqPublisher.publish('loggable_activity_queue', params)
      end

      def params
        {
          action: @action,
          actor_id: @actor.id,
          actor_type: @actor.class.name,
          actor_display_name: @actor_display_name,
          record_id: @record.id,
          record_type: @record.class,
          payloads: @payloads.to_json
        }
      end
    end
  end
end
