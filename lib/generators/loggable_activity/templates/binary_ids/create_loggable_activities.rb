# frozen_string_literal: true

class CreateLoggableActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :loggable_activities, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :action
      t.references :actor, polymorphic: true, null: true, type: :uuid
      t.string :encrypted_actor_display_name
      t.string :encrypted_record_display_name
      t.references :record, polymorphic: true, null: true, type: :uuid

      t.timestamps
    end

    create_table :loggable_payloads, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.references :record, polymorphic: true, null: true, type: :uuid
      t.json :encrypted_attrs
      t.integer :payload_type, default: 0
      t.boolean :data_owner, default: false
      t.references :activity, type: :uuid, foreign_key: { to_table: 'loggable_activities', class_name: 'LoggableActivity::Activity' }

      t.timestamps
    end

    create_table :loggable_encryption_keys, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :key
      t.references :parent_key, type: :uuid, foreign_key: { to_table: 'loggable_encryption_keys', on_delete: :nullify }
      t.references :record, polymorphic: true, type: :uuid
    end
  end
end
