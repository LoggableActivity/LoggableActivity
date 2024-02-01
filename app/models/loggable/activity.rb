# frozen_string_literal: true

# This is the activity log. It contains an agregation of payloads.
# It reprecent one activity for the log

module Loggable
  class Activity < ApplicationRecord
    has_many :payloads, class_name: 'Loggable::Payload', dependent: :destroy
    accepts_nested_attributes_for :payloads

    validates :actor, presence: true
    validates :action, presence: true

    validate :must_have_at_least_one_payload

    belongs_to :record, polymorphic: true, optional: true
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

    def attrs
      @attrs ||= payloads_attrs
    end

    def update_activity_attrs
      {
        update_attrs:,
        updated_relations_attrs: updated_relations
      }
    end

    def primary_payload_attrs
      primary_payload ? primary_payload.attrs : {}
    end

    def primary_payload
      @primary_payload = ordered_payloads.find { |p| p.payload_type == 'primary_payload' }
    end

    def ordered_payloads
      @ordered_payloads ||= payloads.order(:payload_type)
    end

    def relations_attrs
      attrs.filter { |p| p[:payload_type] == 'current_association' }
    end

    def updated_relations
      grouped_associations = attrs.group_by { |p| p[:record_class] }

      grouped_associations.map do |record_class, payloads|
        previous_attrs = payloads.find { |p| p[:payload_type] == 'previous_association' }
        current_attrs = payloads.find { |p| p[:payload_type] == 'current_association' }
        next if previous_attrs.nil? && current_attrs.nil?

        { record_class:, previous_attrs:, current_attrs: }
      end.compact
    end

    # def destroyed_relations
    #   attrs.filter { |p| p[:payload_type] == 'destroy_payload' }
    # end

    def update_attrs
      update_payload_attrs = attrs.find { |p| p[:payload_type] == 'update_payload' }
      return nil unless update_payload_attrs

      update_payload_attrs.delete(:payload_type)
      update_payload_attrs
    end

    def previous_associations_attrs
      attrs.select { |p| p[:payload_type] == 'previous_association' }
    end

    def record_display_name
      Loggable::Encryption.decrypt(encrypted_record_display_name, record_key)
    end

    def actor_display_name
      Loggable::Encryption.decrypt(encrypted_actor_display_name, actor_key)
    end

    def actor_key
      Loggable::EncryptionKey
        .for_record_by_type_and_id(actor_type, actor_id)&.key
    end

    def record_key
      Loggable::EncryptionKey
        .for_record_by_type_and_id(record_type, record_id)&.key
    end

    def payloads_attrs
      ordered_payloads.map do |payload|
        {
          record_class: payload.record_type,
          payload_type: payload.payload_type,
          attrs: payload.attrs
        }
      end
    end

    def must_have_at_least_one_payload
      errors.add(:payloads, 'must have at least one payload') if payloads.empty?
    end
  end
end
