# frozen_string_literal: true

class CreateLoggableEncryptionKeys < ActiveRecord::Migration[6.1]
  def change
    create_table :loggable_encryption_keys do |t|
      t.references :parrent_key, foreign_key: { to_table: 'loggable_encryption_keys', on_delete: :nullify }
      t.string :key
      t.references :record, polymorphic: true, on_delete: :nullify
    end
  end
end
