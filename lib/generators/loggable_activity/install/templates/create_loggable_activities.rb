# frozen_string_literal: true

class CreateLoggableActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :loggable_activity_encryption_keys do |t|
      t.references :record, polymorphic: true, null: true, index: true
      t.string :secret_key
      t.datetime :delete_at

      t.timestamps
    end

    create_table :loggable_activity_activities do |t|
      t.string :action
      t.references :actor, polymorphic: true, null: true
      t.string :encrypted_actor_name
      t.references :record, polymorphic: true, null: true

      t.timestamps
    end

    create_table :loggable_activity_payloads do |t|
      t.references :activity, null: false, foreign_key: { to_table: 'loggable_activity_activities' }
      t.references :encryption_key, null: false, foreign_key: { to_table: 'loggable_activity_encryption_keys' }
      t.references :record, polymorphic: true, null: true, index: true
      t.string :encrypted_record_name
      t.json :encrypted_attrs
      t.integer :related_to_activity_as, default: 0
      t.boolean :data_owner, default: false
      t.string :route
      t.boolean :current_payload, default: true
      t.json :public_attrs, default: {}

      t.timestamps
    end

    create_table :loggable_activity_data_owners do |t|
      t.references :record, polymorphic: true, null: true, index: true
      t.references :encryption_key, null: false, foreign_key: { to_table: 'loggable_activity_encryption_keys' }

      t.timestamps
    end
  end
end
