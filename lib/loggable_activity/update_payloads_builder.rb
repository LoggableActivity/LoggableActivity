# frozen_string_literal: true


module LoggableActivity
  # This module is responsible for building update payloads used in loggable activities.
  module UpdatePayloadsBuilder

    # Builds payloads for an activity update event.
    #
    #  Example:
    #    build_update_payloads
    #
    #   Returns:
    #   [
    #     [0] #<LoggableActivity::Payload:0x00000001047d31d8> {
    #       :id => nil,
    #       :record_type => "Demo::Club",
    #       :record_id => 7,
    #       :encrypted_attrs => {
    #         "changes" => [
    #           [0] {
    #             "name" => {
    #               "from" => "+aQznZK64KLQ8wsyZlSOGQbqm+J8gDX93rNFeF+wY68=\n",
    #               "to" => "OdS834ZDS06+AYxmz4cUjhtgk7Jc8NoOVAAqR81Is7w=\n"
    #             }
    #           }
    #         ]
    #       },
    #       :payload_type => "update_payload",
    #       :data_owner => false,
    #       :activity_id => nil,
    #       :created_at => nil,
    #       :updated_at => nil
    #     },
    #     [1] #<LoggableActivity::Payload:0x0000000107847f80> {
    #       :id => nil,
    #       :record_type => "Demo::Address",
    #       :record_id => 7,
    #       :encrypted_attrs => {
    #         "street" => "W7cmT22Bb5TKVmtxTYJt1w==\n",
    #         "city" => "AAwdTI7Xo86cMbFBAMsMIw==\n",
    #         "country" => "7gu5wdu6O9tD7Q7+EDOqAg==\n",
    #         "postal_code" => "ljjfT6MXGNK33/PUyi6Nmw==\n"
    #       },
    #       :payload_type => "previous_association",
    #       :data_owner => false,
    #       :activity_id => nil,
    #       :created_at => nil,
    #       :updated_at => nil
    #     },
    #     [2] #<LoggableActivity::Payload:0x0000000107802a98> {
    #       :id => nil,
    #       :record_type => "Demo::Address",
    #       :record_id => 8,
    #       :encrypted_attrs => {
    #         "street" => "CuULVgIEgrOcWBxegKEvSg==\n",
    #         "city" => "QbvodOYMvNFpkvsCprqGqg==\n",
    #         "country" => "/N03d1OL3TY+aaiPUQ5N1A==\n",
    #         "postal_code" => "ZZu3S5tnaTeq+wBu0dPKBw==\n"
    #       },
    #       :payload_type => "current_association",
    #       :data_owner => false,
    #       :activity_id => nil,
    #       :created_at => nil,
    #       :updated_at => nil
    #     }
    #   ]
    #
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

    def primary_update_attrs
      previous_values = saved_changes.transform_values(&:first)
      current_values = saved_changes.transform_values(&:last)

      [previous_values, current_values]
    end

    def build_primary_update_payload(previous_values, current_values)
      return if previous_values == current_values

      encrypted_update_attrs = encrypted_update_attrs(previous_values, current_values)
      @update_payloads << LoggableActivity::Payload.new(
        record: @record,
        payload_type: 'update_payload',
        encrypted_attrs: encrypted_update_attrs
      )
    end

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

    def build_update_relation_payloads(relation_config)
      relation_config.each_key do |key|
        case key
        when 'belongs_to'
          build_relation_update_for_belongs_to(relation_config)
        end
      end
    end

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
          relation_record.attributes,
          relation_config['loggable_attrs'],
          relation_record,
          payload_type
        )
      end
    end

    def build_relation_update_payload(_attrs, loggable_attrs, record, payload_type)
      encryption_key = LoggableActivity::EncryptionKey.for_record(record)&.key
      encrypted_attrs = relation_encrypted_attrs(record.attributes, loggable_attrs, encryption_key)

      @update_payloads << LoggableActivity::Payload.new(
        record:,
        encrypted_attrs:,
        payload_type:
      )
    end

    def relation_encrypted_attrs(attrs, loggable_attrs, encryption_key)
      encrypt_attrs(attrs, loggable_attrs, encryption_key)
    end
  end
end
