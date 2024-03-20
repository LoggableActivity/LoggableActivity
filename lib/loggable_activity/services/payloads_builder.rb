# frozen_string_literal: true

module LoggableActivity
  module Services
    # This module is responsible for building payloads used in loggable activities.
    class PayloadsBuilder < BasePayloadsBuilder
      # Builds payloads for the loggable activity and returns an array of payload objects.
      #
      # Example call:
      # payloads = ::LoggableActivity::Services::PayloadsBuilder.new(record, initial_payloads).build
      #
      # Returns an Array of ::LoggableActivity::Payload instances, each representing a payload
      # for the loggable activity. For example:
      # [
      #   #<::LoggableActivity::Payload:0x0000000109658718 @encryption_key="key1", @record=#<MockRecord:0x0000000105000000 @name="Record1">, @encrypted_record_name="Encrypted Name1", @encrypted_attrs={...}, @related_to_activity_as="primary_payload", @data_owner=true, @route="route1">,
      #   #<::LoggableActivity::Payload:0x0000000109658720 @encryption_key="key2", @record=#<MockRecord:0x0000000105000001 @name="Record2">, @encrypted_record_name="Encrypted Name2", @encrypted_attrs={...}, @related_to_activity_as="has_one_payload", @data_owner=true, @route="route2">
      # ]
      #
      def build
        build_primary_payload
        build_relations_payloads
        @payloads
      end

      private

      # Builds the primary payload.
      def build_primary_payload
        options = { related_to_activity_as: 'primary_payload', current_payload: true, data_owner: true }
        build_encrypted_payload(@record, options)
      end

      # Builds the relations payloads.
      def build_relations_payloads
        @relations.each do |relation_config|
          build_relation_payload(relation_config)
        end
      end

      # Builds payloads for relations definded in the configuration.
      #
      # @param relation_config [Hash] The configuration of the relation.
      def build_relation_payload(relation_config)
        relation_config.each_key do |key|
          case key
          when 'belongs_to'
            build_belongs_to_payload(relation_config)
          when 'has_one'
            build_has_one_payload(relation_config)
          when 'has_many'
            build_has_many_payloads(relation_config)
          end
        end
      end

      # Builds payloads for has_many relations.
      def build_has_many_payloads(relation_config)
        relation = (relation_config['has_many']).to_s
        records = @record.send(relation)
        data_owner = relation_config['data_owner']
        options = { related_to_activity_as: 'has_many_payload', current_payload: true, data_owner: }
        records.each do |record|
          record.disable_hooks = true
          build_encrypted_payload(record, options)
        end
      end

      # Builds the payload for a has_one relation.
      def build_has_one_payload(relation_config)
        relation = (relation_config['has_one']).to_s
        record = @record.send(relation)
        return if record.nil?

        data_owner = relation_config['data_owner']
        options =
          { related_to_activity_as: 'has_one_payload', current_payload: true, data_owner: }

        build_encrypted_payload(record, options)
      end

      def build_belongs_to_payload(relation_config)
        relation = (relation_config['belongs_to']).to_s
        record = @record.send(relation)
        return if record.nil?

        data_owner = relation_config['data_owner']

        if data_owner
          encryption_key = encryption_key_for_record(@record)
          DataOwner.create!(record:, encryption_key:)
        end
        options = { related_to_activity_as: 'belongs_to_payload', current_payload: true, data_owner: }

        build_encrypted_payload(record, options)
      end
    end
  end
end
