class Demo::Address < ApplicationRecord
  has_many :users, foreign_key: :demo_address_id
end
