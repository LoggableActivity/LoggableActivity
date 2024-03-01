# frozen_string_literal: true

module LoggableActivity
  # This module is responsible for building update payloads used in loggable activities.
  module UpdatePayloadsBuilder
    # Builds payloads for an activity update event.
    def build_update_payloads
      @update_payloads = []

      previous_values, current_values = primary_update_attrs
      build_primary_update_payload(previous_values, current_values)

      self.class.relations.each do |relation_config|
        build_update_relation_payloads(relation_config)
      end
      @update_payloads
    end

    private

    # Fetch the previous and current values of the primary record.
    def primary_update_attrs
      previous_values = saved_changes.transform_values(&:first)
      current_values = saved_changes.transform_values(&:last)

      [previous_values, current_values]
    end

    # Builds the primary update payload.
    def build_primary_update_payload(previous_values, current_values)
      return if previous_values == current_values

      encrypted_update_attrs = encrypted_update_attrs(previous_values, current_values)
      @update_payloads << LoggableActivity::Payload.new(
        record: @record,
        payload_type: 'update_payload',
        encrypted_attrs: encrypted_update_attrs,
        route: self.class.route
      )
    end

    # Returns the encrypted attributes for the update payload.
    def encrypted_update_attrs(previous_values, current_values)
      changes = []
      changed_attrs = previous_values.slice(*self.class.loggable_attrs)
      changed_attrs.each do |key, from_value|
        from = LoggableActivity::Encryption.encrypt(from_value, primary_encryption_key)
        to_value = current_values[key]
        to = LoggableActivity::Encryption.encrypt(to_value, primary_encryption_key)
        changes << { key => { from:, to: } }
      end
      { changes: }
    end

    # Builds update payloads for relations.
    def build_update_relation_payloads(relation_config)
      relation_config.each_key do |key|
        case key
        when 'belongs_to'
          build_relation_update_for_belongs_to(relation_config)
        when 'has_one'
          build_relation_update_for_has_one(relation_config)
        when 'has_many'
          build_relation_update_for_has_many(relation_config)
        end
      end
    end

    # Builds the update payload for a has_many relation.
    def build_relation_update_for_has_many(relation_config)
      # NOTE: This method is not implemented yet.
      # It requires that there is a form where it is possible to change
      # the related records. This is not implemented yet. in the Demo app
      # puts relation_config['has_many']
    end

    # Builds the update payload for a has_one relation.
    def build_relation_update_for_has_one(relation_config)
      # NOTE: This method is not implemented yet.
      # It requires that there is a form where it is possible to change
      # the related records. This is not implemented yet. in the Demo app
      # puts relation_config['has_one']
    end

    # Builds the update payload for a belongs_to relation.
    def build_relation_update_for_belongs_to(relation_config)
      relation_id = "#{relation_config['belongs_to']}_id"
      model_class_name = relation_config['model']
      model_class = model_class_name.constantize

      return unless saved_changes.include?(relation_id)

      relation_id_changes = saved_changes[relation_id]
      previous_relation_id, current_relation_id = relation_id_changes

      [previous_relation_id, current_relation_id].each_with_index do |id, index|
        relation_record = id ? model_class.find_by(id:) : nil
        next unless relation_record

        payload_type = index.zero? ? 'previous_association' : 'current_association'
        build_relation_update_payload(
          relation_config,
          relation_record,
          payload_type
        )
      end
    end

    # Builds the update payload for a relation.
    def build_relation_update_payload(relation_config, record, payload_type)
      encryption_key = LoggableActivity::EncryptionKey.for_record(record)&.key
      encrypted_attrs = relation_encrypted_attrs(record.attributes, relation_config['loggable_attrs'], encryption_key)

      @update_payloads << LoggableActivity::Payload.new(
        record:,
        encrypted_attrs:,
        payload_type:,
        route: relation_config['route']
      )
    end

    # Returns the encrypted attributes for a relation.
    def relation_encrypted_attrs(attrs, loggable_attrs, encryption_key)
      encrypt_attrs(attrs, loggable_attrs, encryption_key)
    end
  end
end
