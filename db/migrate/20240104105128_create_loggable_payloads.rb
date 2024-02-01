# frozen_string_literal: true

class CreateLoggablePayloads < ActiveRecord::Migration[7.1]
  def change
    create_table :loggable_payloads, id: :uuid do |t|
      t.uuid :record_id
      t.string :record_type
      t.json :encrypted_attrs
      t.integer :payload_type, default: 0
      t.boolean :data_owner, default: false

      # Manually create a UUID column for the foreign key
      t.uuid :activity_id, null: false
    end

    # Add foreign key constraint
    add_foreign_key :loggable_payloads, :loggable_activities, column: :activity_id
  end
end
