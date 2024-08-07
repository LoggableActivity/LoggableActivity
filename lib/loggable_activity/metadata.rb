# frozen_string_literal: true

require 'active_record'

module LoggableActivity
  # This class represents metadata for an activity.
  # This is usefull when searching for activities related to a record or an actor.
  # Hence the actor 'name' and record 'name' are encrypted
  class Metadata < ActiveRecord::Base
    belongs_to :record, polymorphic: true, optional: true
    belongs_to :actor, polymorphic: true, optional: true
    def self.ransackable_attributes(_auth_object = nil)
      %w[action actor_display_name actor_id actor_type created_at id id_value record_display_name record_id record_type
         updated_at]
    end
  end
end
