# frozen_string_literal: true

module Demo
  class Address < ApplicationRecord
    include Loggable::Activities
    has_many :users, foreign_key: :demo_address_id, dependent: :nullify
    has_many :clubs, foreign_key: :demo_address_id, dependent: :nullify
    validates :street, presence: true

    def full_address
      "#{street} #{city}, #{country} #{postal_code}"
    end
  end
end
