# frozen_string_literal: true

module LoggableActivity
  # Namespace for services
  module Services
    # This class is responsible for building destroy payloads used in loggable activities.
    class DestroyPayloadsBuilder < BasePayloadsBuilder
      # Build payloads for a ::LoggableActivity::Activity.
      #
      #  Example:
      #    build_payloads
      #
      #  Returns:
      #   #<::LoggableActivity::Payload:0x0000000109658718> {
      #                    :id => 129,
      #           :record_type => "Demo::Club",
      #             :record_id => 4,
      #       :encrypted_attrs => {
      #           "name" => "z/jigjcm3Fb89L7QT8XiNhvVgjtRXKkmg/xohR6wIc0=\n"
      #       },
      #
      def build
        build_primary_destroy_payload
        build_relations_destroy_payloads
        @payloads
      end

      private

      def build_primary_destroy_payload
        encryption_key = encryption_key_for_record(@record)
        secret_key = encryption_key.secret_key
        encrypt_attrs(@record.attributes, @record.class.loggable_attrs, secret_key)
        display_name_for_record(@record)

        build_encrypted_destroy_payload(@record, 'primary_destroy_payload')
      end

      def build_relations_destroy_payloads
        @relations.each do |relation_config|
          build_relation_destroy_payload(relation_config)
        end
      end

      def build_relation_destroy_payload(relation_config)
        relation_config.each_key do |key|
          case key
          when 'belongs_to'
            # build_belongs_to_destroy_payload(relation_config)
          when 'has_one'
            build_has_one_destroy_payload(relation_config)
          when 'has_many'
            build_has_many_destroy_payloads(relation_config) # if relation_config['data_owner']
          end
        end
      end

      def build_belongs_to_destroy_payload(relation_config)
        relation = (relation_config['belongs_to']).to_s
        record = @record.send(relation)
        return if record.nil? ||

                  build_encrypted_destroy_payload(record, 'belongs_to_destroy_payload')

        encryption_key_for_record(record).mark_as_deleted!
        # payload[:encryption_key].mark_as_deleted!
      end

      def build_has_one_destroy_payload(relation_config)
        relation = (relation_config['has_one']).to_s
        record = @record.send(relation)
        return nil if record.nil?

        record.disable_hooks = true

        build_encrypted_destroy_payload(record, 'has_one_destroy_payload')
      end

      def build_has_many_destroy_payloads(relation_config)
        relation = (relation_config['has_many']).to_s
        records = @record.send(relation)
        records.each do |record|
          record.disable_hooks = true
          build_encrypted_destroy_payload(record, 'has_many_destroy_payload')
          # build_encrypted_payload(
          #   record,
          #   'has_many_destroy_payload',
          #   relation_config['data_owner'],
          #   true
          # )
        end
      end

      def build_encrypted_destroy_payload(record, related_to_activity_as)
        encryption_key = encryption_key_for_record(record)
        secret_key = encryption_key.secret_key
        encrypted_attrs = encrypt_attrs(record.attributes, record.class.loggable_attrs, secret_key)
        payload_display_name = display_name_for_record(record)

        @payloads << ::LoggableActivity::Payload.new(
          encryption_key:,
          record_id: nil,
          record_type: record.class.name,
          payload_display_name:,
          encrypted_attrs:,
          related_to_activity_as:,
          data_owner: true,
          route: '',
          public_attrs: public_attributes(record),
          current_payload: true
        )
        encryption_key
      end
    end
  end
end
