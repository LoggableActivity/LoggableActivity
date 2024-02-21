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

    # Returns a list of attributes of the activity includig the indliced relations.
    # The included relations are devined in the 'config/loggable_activity.yaml' file.
    # The attributes are packed in a way that they can be used to display the activity in the UI.
    #
    # Example:
    #   @activity.attrs
    #
    # Returns:
    #   [
    #     {
    #       record_class: "User",
    #       payload_type: "primary_payload",
    #       attrs: {
    #         "first_name" => "David",
    #         "last_name" => "Bowie",
    #         "age" => "69",
    #         "email" => "david@example.com",
    #         "user_type" => "Patient"
    #       }
    #     },
    #     {
    #       record_class: "Demo::UserProfile",
    #       payload_type: "current_association",
    #       attrs: {
    #         "sex" => "Male",
    #         "religion" => "Agnostic"
    #       }
    #     },
    #     {
    #       record_class: "Demo::Address",
    #       payload_type: "current_association",
    #       attrs: {
    #         "street" => "Eiffel Tower",
    #         "city" => "Paris",
    #         "country" => "France",
    #         "postal_code" => "75007"
    #       }
    #     },
    #     {
    #       record_class: "Demo::Club",
    #       payload_type: "current_association",
    #       attrs: {
    #         "name" => "Mystic Fusion Lounge"
    #       }
    #     }
    #  ]
    #
    def attrs
      ordered_payloads.map do |payload|
        {
          record_class: payload.record_type,
          payload_type: payload.payload_type,
          attrs: payload.attrs
        }
      end
    end

    # Returns the attributes of an upddate activity.
    #
    # Example:
    #   @activity.update_activity_attrs
    #
    # Returns:
    #   {
    #     # Update attributes for Demo::Club
    #     update_attrs: {
    #       record_class: "Demo::Club",
    #       attrs: [
    #         {
    #           "name" => {
    #             # Previous name
    #             from: "Electric Oasis Club",
    #             # New name
    #             to: "Electric Oasis Club nr 5"
    #           }
    #         }
    #       ]
    #     },
    #     # Updated relations attributes
    #     updated_relations_attrs: [
    #       {
    #         record_class: "Demo::Address",
    #         previous_attrs: {
    #           # Record class
    #           record_class: "Demo::Address",
    #           # Previous association payload type
    #           payload_type: "previous_association",
    #           # Previous attributes for Demo::Address
    #           attrs: {
    #             "street" => "Ice Hotel, Marknadsvägen 63",
    #             "city" => "Jukkasjärvi",
    #             "country" => "Sweden",
    #             "postal_code" => "981 91"
    #           }
    #         },
    #         current_attrs: {
    #           record_class: "Demo::Address",
    #           # Current association payload type
    #           payload_type: "current_association",
    #           # Current attributes for Demo::Address
    #           attrs: {
    #             "street" => "The Palace of Versailles",
    #             "city" => "Versailles",
    #             "country" => "France",
    #             "postal_code" => "78000"
    #           }
    #         }
    #       }
    #     ]
    #   }
    #
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
    #   {
    #       "first_name" => "David",
    #       "last_name" => "Bowie",
    #             "age" => "69",
    #           "email" => "david@example.com",
    #       "user_type" => "Patient"
    #   }
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
    #       record_class: "Demo::Address",
    #       # Current association payload type
    #       payload_type: "current_association",
    #       # Current attributes for Demo::Address
    #       attrs: {
    #         "street" => "The Palace of Versailles",
    #         "city" => "Versailles",
    #         "country" => "France",
    #         "postal_code" => "78000"
    #       }
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

    def update_attrs
      update_payload_attrs = attrs.find { |p| p[:payload_type] == 'update_payload' }
      return nil unless update_payload_attrs

      update_payload_attrs.delete(:payload_type)
      update_payload_attrs
    end

    def primary_payload
      ordered_payloads.find { |p| p.payload_type == 'primary_payload' }
    end

    def updated_relations_attrs
      grouped_associations = attrs.group_by { |p| p[:record_class] }

      grouped_associations.map do |record_class, payloads|
        previous_attrs = payloads.find { |p| p[:payload_type] == 'previous_association' }
        current_attrs = payloads.find { |p| p[:payload_type] == 'current_association' }
        next if previous_attrs.nil? && current_attrs.nil?

        { record_class:, previous_attrs:, current_attrs: }
      end.compact
    end

    def previous_associations_attrs
      attrs.select { |p| p[:payload_type] == 'previous_association' }
    end

    def ordered_payloads
      payloads.order(:payload_type)
    end

    def record_key
      return nil if record.nil?

      LoggableActivity::EncryptionKey.for_record(record)&.key
    end

    def actor_key
      return nil if actor.nil?

      LoggableActivity::EncryptionKey.for_record(actor)&.key
    end

    def must_have_at_least_one_payload
      errors.add(:payloads, 'must have at least one payload') if payloads.empty?
    end
  end
end
