# frozen_string_literal: true

module Loggable
  class XjsonPayloadFactory
    def initialize(loggable_activity)
      @loggable_activity = loggable_activity
    end

    def build_payload
      {
        activity: @loggable_activity.attrs,
        payloads_attrs:
      }
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
  end
end
