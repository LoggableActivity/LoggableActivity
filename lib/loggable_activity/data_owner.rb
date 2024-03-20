# frozen_string_literal: true

require 'active_record'
require 'awesome_print'

module LoggableActivity
  class DataOwner < ActiveRecord::Base
    self.table_name = 'loggable_data_owners'
    # belongs_to :record, class_name: 'LoggableActivity::Record'
    belongs_to :record, polymorphic: true, optional: true
    belongs_to :encryption_key, class_name: '::LoggableActivity::EncryptionKey'

    def mark_as_deleted!
      encryption_key.mark_as_deleted!
    end
  end
end
