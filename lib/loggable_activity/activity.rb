# frozen_string_literal: true

require 'active_record'

module LoggableActivity
  # Represents one action in the activity log.
  class Activity < ActiveRecord::Base
    self.table_name = 'loggable_activities'
    # Associations
    has_many :payloads, class_name: 'LoggableActivity::Payload', dependent: :destroy
    belongs_to :record, polymorphic: true, optional: true
    belongs_to :actor, polymorphic: true, optional: true

    accepts_nested_attributes_for :payloads

    # Validations
    validates :actor, presence: true
    validates :action, presence: true
    validate :must_have_at_least_one_payload

    # Returns an array of hashes, each representing an activity's attributes and its associated relations. The structure and relations to include are specified in 'config/loggable_activity.yaml'. This format is designed for UI display purposes.
    #
    # Each hash in the array contains:
    # - :record_type: The class name of the record.
    # - :payload_type: A descriptor of the payload's role (e.g., 'primary_payload' or 'current_association').
    # - :attrs: A hash of the record's attributes.
    #
    # Example usage:
    #   @activity.attrs
    #
    # Sample return value:
    #   [
    #     { record_type: MODEL_NAME, payload_type: "primary_payload", attrs: { "KEY" => "VALUE", ... } },
    #     { record_type: MODEL_NAME, payload_type: "current_association", attrs: { "KEY" => "VALUE", ... } },
    #     ...
    #   ]
    def attrs
      ordered_payloads.map do |payload|
        {
          record_type: payload.record_type,
          record_id: payload.record_id,
          payload_type: payload.payload_type,
          attrs: payload.attrs,
          route: payload.payload_route
        }
      end
    end

    # Returns a hash describing the attributes of an update activity, including updated attributes for a record and any updated related attributes.
    #
    # Example:
    #   @activity.update_activity_attrs
    #
    # The return value is structured as follows:
    # - :update_attrs contains the attributes of the record being updated, detailing changes from previous to new values.
    # - :updated_relations_attrs is an array of hashes, each representing an updated related record. Each hash details the previous and current attributes of the relation.
    #
    # Example Return Structure:
    #   {
    #     update_attrs: {
    #       record_class: "CLASS.NAME",
    #       attrs: [{ "KEY" => { from: "OLD_VALUE", to: "NEW_VALUE" } }]
    #     },
    #     updated_relations_attrs: [
    #       {
    #         record_class: "CLASS.NAME",
    #         previous_attrs: { attrs: { "KEY" => "VALUE", ... } },
    #         current_attrs: { attrs: { "KEY" => "VALUE", ... } }
    #       }
    #     ]
    #   }
    def update_activity_attrs
      {
        update_attrs:,
        updated_relations_attrs:
      }
    end
    
    # Returns the attributes for the primary payload, without the relations.
    #
    # Example:
    #
    #   @activity.primary_payload_attrs
    #
    # Returns:
    #   { "KEY_A" => "VALUE_A", "KEY_B" => "VALUE_B", ... }
    #
    def primary_payload_attrs
      primary_payload ? primary_payload.attrs : {}
    end

    # Returns the attributes for the relations.
    #
    # Example:
    #
    #   @activity.relations_attrs
    #
    # Returns:
    #   [
    #     {
    #       record_type: CLASS.NAME,
    #       record_id: INTEGER,
    #       payload_type: ENUM 
    #       attrs: { "KEY_A" => "VALUE_A", "KEY_B" => "VALUE_B", ... }
    #     }
    #   ]
    def relations_attrs
      attrs.filter { |p| p[:payload_type] == 'current_association' }
    end

    # Returns the display name for a record. what method to use if defined in '/config/loggable_activity.yaml'
    #
    # Example:
    #
    #   @activity.record_display_name
    #
    # Returns:
    #   "David Bowie"
    #
    def record_display_name
      return I18n.t('loggable.activity.deleted') if encrypted_record_display_name.nil?

      LoggableActivity::Encryption.decrypt(encrypted_record_display_name, record_key)
    end

    # Returns the path for the activity.
    #
    # Example:
    #
    #   @activity.path
    #
    # Returns:
    #   "/path/to/activity"
    #
    def primary_route 
      primary_payload&.payload_route
    end

    # Returns the display name for a actor. what method to use if defined in '/config/loggable_activity.yaml'
    #
    # Example:
    #
    #   @activity.actor_display_name
    #
    # Returns:
    #   "Elvis Presley"
    #
    def actor_display_name
      return I18n.t('loggable.activity.deleted') if encrypted_actor_display_name.nil?

      LoggableActivity::Encryption.decrypt(encrypted_actor_display_name, actor_key)
    end

    # Returns a list of activities for a given actor.
    def self.activities_for_actor(actor, limit = 20, params = { offset: 0 })
      LoggableActivity::Activity.latest(limit, params).where(actor:)
    end

    # Returns a list of activities ordered by creation date.
    def self.latest(limit = 20, params = { offset: 0 })
      offset = params[:offset] || 0
      LoggableActivity::Activity
        .all
        .order(created_at: :desc)
        .includes(:payloads)
        .offset(offset)
        .limit(limit)
    end

    # Returns the last activity.
    def self.last(limit = 1)
      return latest(1).first if limit == 1

      latest(limit)
    end

    private

    # Returns the primary payload associated with the activity.
    #
    # Example usage:
    #   payload = @activity.primary_payload
    #   puts payload.record_type  # => 'SOMD_MODEL_NAME'
    #
    def primary_payload
      ordered_payloads.find { |p| p.payload_type == 'primary_payload' }
    end

    # Returns the attributes for the update+payload.
    def update_attrs
      update_payload_attrs = attrs.find { |p| p[:payload_type] == 'update_payload' }
      return nil unless update_payload_attrs

      update_payload_attrs.delete(:payload_type)
      update_payload_attrs
    end


    # Returns the attributes for the updated relations.
    def updated_relations_attrs
      grouped_associations = attrs.group_by { |p| p[:record_type] }

      grouped_associations.map do |record_type, payloads|
        previous_attrs = payloads.find { |p| p[:payload_type] == 'previous_association' }
        current_attrs = payloads.find { |p| p[:payload_type] == 'current_association' }
        next if previous_attrs.nil? && current_attrs.nil?

        { record_type:, previous_attrs:, current_attrs: }
      end.compact
    end

    # Returns the previous association attributes.
    def previous_associations_attrs
      attrs.select { |p| p[:payload_type] == 'previous_association' }
    end

    # Returns payloads sorted by :payload_type.
    def ordered_payloads
      payloads.order(:payload_type)
    end

    # Returns the key for the logged record.
    def record_key
      return nil if record.nil?

      LoggableActivity::EncryptionKey.for_record(record)&.key
    end

    # Returns the key for the actor.
    def actor_key
      return nil if actor.nil?

      LoggableActivity::EncryptionKey.for_record(actor)&.key
    end

    # Validates that the activity has at least one payload.
    def must_have_at_least_one_payload
      errors.add(:payloads, 'must have at least one payload') if payloads.empty?
    end
  end
end
