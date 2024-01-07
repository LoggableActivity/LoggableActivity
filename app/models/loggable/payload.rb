class Loggable::Payload < ApplicationRecord
  belongs_to :activity
  belongs_to :owner, polymorphic: true, optional: true 
  # validates :owner, presence: true
  validates :attrs, presence: true

end
