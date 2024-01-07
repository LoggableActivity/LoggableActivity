# frozen_string_literal: true

module Demo
  class Address < ApplicationRecord
    has_many :users, foreign_key: :demo_address_id
  end
end
