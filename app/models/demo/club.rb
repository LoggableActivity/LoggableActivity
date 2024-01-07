# frozen_string_literal: true

module Demo
  class Club < ApplicationRecord
    include Loggable::Activities
    has_many :users, foreign_key: :demo_club_id, dependent: :nullify
    belongs_to :demo_address, class_name: 'Demo::Address', foreign_key: :demo_address_id, optional: true
    validates :name, presence: true
  end
end
