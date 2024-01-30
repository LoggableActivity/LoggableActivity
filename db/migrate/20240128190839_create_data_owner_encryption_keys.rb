# frozen_string_literal: true

class CreateDataOwnerEncryptionKeys < ActiveRecord::Migration[7.1]
  def change
    create_table :loggable_data_owner_encryption_keys, id: :uuid do |t|
      t.uuid :data_owner_id
      t.string :data_owner_type
      t.uuid :encryption_key_id
      t.uuid :record_id
      t.string :record_type
    end
    add_foreign_key :loggable_data_owner_encryption_keys, :loggable_encryption_keys, column: :encryption_key_id
  end
end
