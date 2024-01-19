# frozen_string_literal: true

module Loggable
  class JsonPayloadFactory
    def initialize(loggable_activity)
      @loggable_activity = loggable_activity 

    end

    def build_payload
      if validate_data
        {
          activity: @loggable_activity.attrs,
          payloads_attrs: payloads_attrs 
        }.to_json
      else 
        raise StandardError, 'Invalid data'
      end
    end

    def payloads_attrs
      @loggable_activity.payloads.map do |payload|
        payload
          .encoded_attrs
          .merge(
            relation_position: payload.relation_position,
            payload_type: payload.payload_type,
            owner_id: payload.owner_id,
            owner_type: payload.owner_type
          )
      end
    end

    def validate_data
      
      true 
    end

    # Converts the data to JSON format
    def to_json(*_args)
      # implementation goes here
    end

    private

    def payload_for_owner
      {
        display_name: '@loggable_activity.owner_name',
        payload_type: 'owner'
      }
    end

    def payload_for_actor 
      { 
        display_name: '@loggable_activity.actor_name',
        payload_type: 'actor' 
      }
    end
    
    def owner_name
      # return @owner.class.name if @owner.class.owner_name.nil?

      # @owner.send(@owner.class.owner_name.to_sym)
    end

    def build_destroy_payload
    end

    def build_update_payload
      # implementation goes here
    end

    def action_key
      @action_key ||= @owner.class.base_action + ".#{@action}"
    end
    
    def build_payloads
      # payload_builder = Loggable::PayloadBuilder.new(@owner, @actor)
      # payload_builder.build_payloads
    end
  end
end
