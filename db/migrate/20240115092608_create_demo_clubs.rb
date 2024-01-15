class CreateDemoClubs < ActiveRecord::Migration[7.1]
  def change
    create_table :demo_clubs, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
  end
end
