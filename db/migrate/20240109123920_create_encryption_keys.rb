# frozen_string_literal: true

class CreateEncryptionKeys < ActiveRecord::Migration[7.1]
  def change
    create_table :loggable_encryption_keys, id: :uuid do |t|
      t.uuid :record_id
      t.string :record_type
      t.string :encryption_key
    end
  end
end
