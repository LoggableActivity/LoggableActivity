# frozen_string_literal: true

require 'active_record'

module LoggableActivity
  # This class represents metadata for an activity.
  # This is usefull when searching for activities related to a record or an actor.
  # Hence the actor 'name' and record 'name' are encrypted
  class Metadata < ActiveRecord::Base
    belongs_to :record, polymorphic: true, optional: true
    belongs_to :actor, polymorphic: true, optional: true
  end
end
