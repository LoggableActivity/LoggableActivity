# frozen_string_literal: true

class CreateLoggableActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :loggable_activities, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :action
      t.references :actor, polymorphic: true, null: true, type: :uuid
      t.string :actor_display_name
      t.string :record_display_name
      t.references :record, polymorphic: true, null: true, type: :uuid

      t.timestamps
    end

    create_table :loggable_payloads, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.references :activity, foreign_key: { to_table: 'loggable_activities', class_name: '::LoggableActivity::Activity' }, type: :uuid
      t.references :encryption_key, null: false, foreign_key: { to_table: 'loggable_encryption_keys', class_name: '::LoggableActivity::EncryptionKey' }, type: :uuid
      t.references :record, polymorphic: true, null: true, type: :uuid
      t.json :encrypted_attrs
      t.integer :related_to_activity_as, default: 0
      t.string :route
    end

    create_table :loggable_encryption_keys, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :secret_key
      # t.references :parent_key, foreign_key: { to_table: 'loggable_encryption_keys', type: :uuid }
      # t.references :record, polymorphic: true, type: :uuid
    end
  end
end
