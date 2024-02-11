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
  end
end
