# frozen_string_literal: true

class CreateDemoProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :demo_products, id: :uuid do |t|
      t.string :name
      t.string :part_number
      t.decimal :price

      t.timestamps
    end
  end
end
