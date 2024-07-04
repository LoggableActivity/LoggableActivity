# frozen_string_literal: true

class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: true, foreign_key: true
      t.text :bio
      t.string :profile_picture_url
      t.string :location
      t.date :date_of_birth
      t.string :phone_number

      t.timestamps
    end
  end
end
