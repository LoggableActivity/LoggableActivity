module LoggableActivity
  module Services
    # This class is responsible for calling the loggable activity endpoint.
    class EndpointCaller
      def initialize(encrypted_actor_name:, action:, actor:, record:, payloads:)
        @encrypted_actor_name = encrypted_actor_name
        @action = action
        @actor = actor
        @record = record
        @payloads = payloads
      end

      def call
        RabbitmqPublisher
          .publish('users_queue', params)

        # ap @record
        # ap @payloads
        # This is where the endpoint would be called.
        # The endpoint would receive the payloads and log the activity.
      end

      def params
        {
          action: @action,
          actor_id: @actor.id,
          actor_type: @actor.class.name,
          encrypted_actor_name: @encrypted_actor_name,
          record_id: @record.id,
          record_type: @record.class,
          payloads: @payloads.to_json
        }
      end
    end
  end
end
