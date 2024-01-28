class CreateDemoJournals < ActiveRecord::Migration[7.1]
  def change
    create_table :demo_journals, id: :uuid do |t|
      # t.references :patient, null: false, foreign_key: true, type: :uuid
      # t.references :doctor, null: false, foreign_key: true, type: :uuid
      t.string :title
      t.text :body
      t.integer :state, default: 0

      t.uuid :patient_id
      t.uuid :doctor_id

      t.timestamps
    end
  end
end
