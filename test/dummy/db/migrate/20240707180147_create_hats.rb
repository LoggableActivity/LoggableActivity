# frozen_string_literal: true

class CreateHats < ActiveRecord::Migration[7.1]
  def change
    create_table :hats do |t|
      t.string :color
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
