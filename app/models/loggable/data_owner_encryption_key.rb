# frozen_string_literal: true
# This is a join table between encryption keys and data owners.
# In this context, data owners are a user that are related to a record.
# E.g. A jurnal entry on a hospital are related to a docktor and a patient.
# The doctor and the patient are data owners. so the encryption key for the record
# Should be deleted when the journal, doctor or the patient are deleted.

module Loggable
  class DataOwnerEncryptionKey < ApplicationRecord
    # belongs_to :encryption_key
    # belongs_to :data_owner

    # validates :encryption_key_id, presence: true
    # validates :data_owner_id, presence: true
    belongs_to :encryption_key
    belongs_to :data_owner, polymorphic: true
    belongs_to :record, polymorphic: true

    validates :encryption_key_id, presence: true
    validates :data_owner_id, presence: true
    validates :data_owner_type, presence: true
  end
end
