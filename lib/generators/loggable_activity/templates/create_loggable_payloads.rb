# frozen_string_literal: true

class CreateLoggablePayloads < ActiveRecord::Migration[6.1]
  def change
    create_table :loggable_payloads do |t|
      t.references :record, polymorphic: true, null: true
      t.json :encrypted_attrs
      t.integer :payload_type, default: 0
      t.boolean :data_owner, default: false
      t.references :activity, foreign_key: { to_table: 'loggable_activities', class_name: 'LoggableActivity::Activity' }

      t.timestamps
    end
  end
end
