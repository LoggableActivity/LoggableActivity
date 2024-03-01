# frozen_string_literal: true

class CreateLoggableActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :loggable_activities do |t|
      t.string :action
      t.references :actor, polymorphic: true, null: true
      t.string :encrypted_actor_display_name
      t.string :encrypted_record_display_name
      t.references :record, polymorphic: true, null: true

      t.timestamps
    end

    create_table :loggable_payloads do |t|
      t.references :record, polymorphic: true, null: true
      t.json :encrypted_attrs
      t.integer :payload_type, default: 0
      t.boolean :data_owner, default: false
      t.string :route, default: nil
      t.references :activity, foreign_key: { to_table: 'loggable_activities', class_name: 'LoggableActivity::Activity' }

      t.timestamps
    end

    create_table :loggable_encryption_keys do |t|
      t.references :parent_key, foreign_key: { to_table: 'loggable_encryption_keys', on_delete: :nullify }
      t.string :key
      t.references :record, polymorphic: true, on_delete: :nullify
    end
  end
end
