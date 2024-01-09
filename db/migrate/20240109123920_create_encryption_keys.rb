# frozen_string_literal: true

class CreateEncryptionKeys < ActiveRecord::Migration[7.1]
  def change
    create_table :loggable_encryption_keys, id: :uuid do |t|
      t.uuid :owner_id
      t.string :owner_type
      t.string :encryption_key

      t.timestamps
    end
  end
end
