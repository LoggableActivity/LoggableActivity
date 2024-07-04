# frozen_string_literal: true

module LoggableActivity
  module Services
    # This service class builds update payloads when an instance of a model is updated.
    class UpdatePayloadsBuilder < BasePayloadsBuilder
      # Builds payloads for a ::LoggableActivity::Activity.
      def build
        build_primary_update_payload
        build_relations_update_payloads
        @payloads
      end

      private

      # Builds the primary payload.
      def build_primary_update_payload
        previous_values, current_values = saved_changes(@record)
        previous_values = previous_values.slice(*@loggable_attrs)
        current_values = current_values.slice(*@loggable_attrs)
        options = { related_to_activity_as: 'primary_update_payload', current_payload: true, data_owner: true }

        build_encrypted_update_payload(
          @record,
          current_values,
          previous_values,
          options
        )
      end

      # Build the payloads for the relations of the record.
      # only relations included in the configuration, will be logged.
      def build_relations_update_payloads
        @relations.each do |relation_config|
          build_relation_update_payload(relation_config)
        end
      end

      def build_relation_update_payload(relation_config)
        relation_config.each_key do |key|
          case key
          when 'belongs_to'
            build_belongs_to_update_payload(relation_config)
          when 'has_one'
            build_has_one_update_payload(relation_config)
          when 'has_many'
            build_has_many_update_payloads(relation_config)
          end
        end
      end

      # Builds the update payload for a belongs_to relation.
      def build_belongs_to_update_payload(relation_config)
        relation_id = "#{relation_config['belongs_to']}_id"
        model_class_name = relation_config['model']
        model_class = model_class_name.constantize
        data_owner = relation_config['data_owner']

        model_ids = saved_changes(@record).map { |hash| hash[relation_id] }

        model_ids.each_with_index do |id, index|
          record = id ? model_class.find_by(id:) : nil
          next unless record

          options =
            { related_to_activity_as: 'belongs_to_update_payload', current_payload: index == 1, data_owner: }

          build_encrypted_payload(record, options)
        end
      end

      # Builds payloads for has_many relations.
      def build_has_many_update_payloads(relation_config)
        relation = (relation_config['has_many']).to_s
        records = @record.send(relation)
        return nil if records.empty?

        records.each do |record|
          if record.persisted? && record.changes_to_save.any?
            build_has_many_update_payload(relation_config, record)
          elsif record.persisted? && record.saved_changes.any?
            # "no changes to save"
          else
            build_has_many_create_payload(relation_config, record)
          end
        end
      end

      def build_has_many_update_payload(relation_config, record)
        record.disable_hooks = true
        previous_values, current_values = changes_to_save(record)
        loggable_attrs = relation_config['loggable_attrs']
        return if previous_values == current_values

        previous_values = previous_values.slice(*loggable_attrs)
        data_owner = relation_config['data_owner']
        options = { related_to_activity_as: 'has_many_update_payload', current_payload: true, data_owner: }

        build_encrypted_update_payload(
          record,
          current_values,
          previous_values,
          options
        )
      end

      def build_has_many_create_payload(relation_config, record)
        record.disable_hooks = true
        data_owner = relation_config['data_owner']
        options =
          { related_to_activity_as: 'has_many_create_payload', current_payload: true, data_owner: }
        build_encrypted_payload(record, options)
      end

      # Builds the update payload for a has_one relation.
      def build_has_one_update_payload(relation_config)
        relation = (relation_config['has_one']).to_s
        record = @record.send(relation)
        return nil if record.nil?


        previous_values, current_values = changes_to_save(record)
        loggable_attrs = relation_config["loggable_attrs"]
        return if previous_values == current_values

        previous_values = previous_values.slice(*loggable_attrs)
        current_values = current_values.slice(*loggable_attrs)
        data_owner = relation_config['data_owner']
        options = { related_to_activity_as: 'has_one_update_payload', current_payload: true, data_owner: }

        build_encrypted_update_payload(
          record,
          current_values,
          previous_values,
          options
        )
      end

      # Returns the encrypted attributes for the update payload.
      def encrypted_update_attrs(current_values, previous_values, encryption_key)
        changes = []

        previous_values.each do |key, from_value|
          from = ::LoggableActivity::Encryption.encrypt(from_value, encryption_key)
          to_value = current_values[key]
          to = ::LoggableActivity::Encryption.encrypt(to_value, encryption_key)
          changes << { key => { from:, to: } }
        end
        { changes: }
      end

      # Builds the encrypted update payload for a record.
      def build_encrypted_update_payload(record, current_values, previous_values, options = {})
        encryption_key = ::LoggableActivity::EncryptionKey.for_record(record)

        encrypted_attrs = encrypted_update_attrs(
          current_values,
          previous_values,
          encryption_key.secret_key
        )

        build_payload(
          record,
          encryption_key,
          encrypted_attrs,
          options
        )
      end
    end
  end
end
