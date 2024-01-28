# frozen_string_literal: true

class CreateLoggableActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :loggable_activities, id: :uuid do |t|
      t.string :action
      t.uuid :actor_id
      t.string :actor_type
      t.string :encoded_actor_display_name
      t.uuid :record_id
      t.string :record_type
      t.string :encoded_record_display_name
      t.timestamps
    end
  end
end
