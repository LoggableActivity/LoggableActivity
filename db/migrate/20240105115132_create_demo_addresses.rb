# frozen_string_literal: true

class CreateDemoAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :demo_addresses, id: :uuid do |t|
      t.string :street
      t.string :city
      t.string :country
      t.string :postal_code

      t.timestamps
    end
    # add_reference :users, :address, foreign_key: { to_table: :demo_addresses }
  end
end
