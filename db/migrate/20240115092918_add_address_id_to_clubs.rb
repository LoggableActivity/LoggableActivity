# frozen_string_literal: true

class AddAddressIdToClubs < ActiveRecord::Migration[7.1]
  def change
    add_column :demo_clubs, :demo_address_id, :uuid
    # Add foreign key constraint
    add_foreign_key :demo_clubs, :demo_addresses, column: :demo_address_id
  end
end
