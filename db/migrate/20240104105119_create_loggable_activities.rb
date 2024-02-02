# frozen_string_literal: true

class CreateLoggableActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :loggable_activities, id: :uuid do |t|
      t.string :action
      t.references :actor, polymorphic: true, type: :uuid
      # t.uuid :actor_id
      # t.string :actor_type
      t.string :encrypted_actor_display_name
      t.string :encrypted_record_display_name
      t.references :record, polymorphic: true, type: :uuid
      # t.uuid :record_id
      # t.string :record_type
      t.timestamps
    end
  end
end
