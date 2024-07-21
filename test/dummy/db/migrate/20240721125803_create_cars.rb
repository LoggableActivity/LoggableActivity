# frozen_string_literal: true

class CreateCars < ActiveRecord::Migration[7.1]
  def change
    create_table :cars do |t|
      t.string :color
      t.string :brand
      t.integer :age

      t.timestamps
    end
  end
end
