class CreateLoggableActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :loggable_activities, id: :uuid do |t|
      t.string :key
      t.uuid :who_did_it

      t.timestamps
    end
  end
end
