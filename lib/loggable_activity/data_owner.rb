# frozen_string_literal: true

require 'active_record'

module LoggableActivity
  # This class represends an additional data owner for a record.
  # For it to kick in, the data_owner configuration has to be set to true in the loggable_activity.yaml file.
  class DataOwner < ActiveRecord::Base
    belongs_to :record, polymorphic: true, optional: true
    belongs_to :encryption_key, class_name: '::LoggableActivity::EncryptionKey'

    # When a record is deleted, all data owner added to the record is also deleted.
    def mark_as_deleted!
      encryption_key.mark_as_deleted!
    end
  end
end
