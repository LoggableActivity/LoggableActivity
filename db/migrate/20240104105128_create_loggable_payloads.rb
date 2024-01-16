# frozen_string_literal: true

class CreateLoggablePayloads < ActiveRecord::Migration[7.1]
  def change
    create_table :loggable_payloads, id: :uuid do |t|
      t.uuid :owner_id
      t.string :owner_type
      t.string :name
      t.json :encoded_attrs
      t.string :payload_type, default: 'primary'
      t.integer :relation_position, default: 0

      # Manually create a UUID column for the foreign key
      t.uuid :activity_id, null: false

      t.timestamps
    end

    # Add foreign key constraint
    add_foreign_key :loggable_payloads, :loggable_activities, column: :activity_id
  end
end
