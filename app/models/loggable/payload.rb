class Loggable::Payload < ApplicationRecord
  belongs_to :activity
  validates :owner, :attrs, presence: true
  validates :attrs, :attrs, presence: true
end
