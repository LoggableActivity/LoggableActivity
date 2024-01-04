class Loggable::Activity < ApplicationRecord
  has_many :payloads, class_name: 'Loggable::Payload', dependent: :destroy

  validates :who_did_it, presence: true

  validate :must_have_at_least_one_payload

  private

  def must_have_at_least_one_payload
    errors.add(:payloads, 'must have at least one payload') if payloads.empty?
  end
end
