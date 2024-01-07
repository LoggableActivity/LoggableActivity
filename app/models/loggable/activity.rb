# frozen_string_literal: true

module Loggable
  class Activity < ApplicationRecord
    has_many :payloads, class_name: 'Loggable::Payload', dependent: :destroy
    accepts_nested_attributes_for :payloads

    validates :actor, presence: true
    validates :action, presence: true

    validate :must_have_at_least_one_payload

    belongs_to :owner, polymorphic: true, optional: true
    belongs_to :actor, polymorphic: true, optional: false

    def self.activities_for_actor(actor)
      Loggable::Activity.where(actor:).order(created_at: :desc)
    end

    def self.latest(limit = 20, params = { offset: 0 })
      offset = params[:offset] || 0
      Loggable::Activity
        .all
        .order(created_at: :desc)
        .offset(offset)
        .limit(limit)
    end

    # def attrs
    #   # Loggable::PresentationBuilder
    #     # .new(self)
    #     # .attrs
    #     {}
    # end

    def primary_attrs
      attrs[:primary]
    end

    def relations_attrs
      attrs[:relations]
    end

    def attrs
      {
        id:,
        action:,
        actor_id:,
        actor_type:,
        owner_id:,
        owner_type:,
        created_at:,
        actor_display_name: encoded_actor_display_name,
        owner_display_name: encoded_owner_display_name
      }
    end

    # def json_payload
    #   json_payload_factory =
    #     Loggable::JsonPayloadFactory.new(self)
    #   json_payload_factory
    #     .build_payload
    # end

    # def payload
    #   JSON.parse(json_payload)
    # end

    private

    def must_have_at_least_one_payload
      errors.add(:payloads, 'must have at least one payload') if payloads.empty?
    end
  end
end
