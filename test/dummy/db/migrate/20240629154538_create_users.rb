# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, null: false, default: ''
      t.string :password, null: false, default: 'password'
      t.integer :age, null: false, default: 37
      t.string :user_type, null: false, default: 'customer'
      t.references :company, null: true
      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    # add_index :users, :company_id
  end
end
