class AddAddressToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :demo_address_id, :uuid
    # Add foreign key constraint
    add_foreign_key :users, :demo_addresses, column: :demo_address_id
  end
end
