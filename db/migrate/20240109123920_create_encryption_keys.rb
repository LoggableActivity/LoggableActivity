# frozen_string_literal: true

class CreateEncryptionKeys < ActiveRecord::Migration[7.1]
  def change
    create_table :loggable_encryption_keys, id: :uuid do |t|
      t.uuid :parrent_key_id
      t.uuid :record_id
      t.string :record_type
      t.string :key
    end

    add_index :loggable_encryption_keys, %i[record_type record_id]
  end
end
