# frozen_string_literal: true

module Loggable
  class PresentationBuilder
    def initialize(activity, activity_type = :show)
      @activity = activity
      @activity_type = activity_type
      @payloads_attrs = payloads_attrs(activity)
      @activity_attrs = activity.attrs
    end

    def action
      @activity_attrs[:action]
    end

    def created_at
      @activity_attrs[:created_at]
    end

    def actor_display_name
      encoded_display_name = @activity_attrs[:actor_display_name]
      Loggable::Encryption.decrypt(encoded_display_name, actor_key)
    end

    def owner_display_name
      encoded_display_name = @activity_attrs[:owner_display_name]
      return '*********' if owner_key.nil?

      Loggable::Encryption.decrypt(encoded_display_name, owner_key)
    end

    def owner_type
      @activity_attrs[:owner_type]
    end

    def payloads
      case @activity_type
      when :show, :create, :destrouy
        basic_payloads(@payloads_attrs)
      else
        update_payloads
      end
    end

    def basic_payloads(payload_attrs)
      payload_attrs.flat_map do |attrs|
        decrypted_payload(attrs)
      end
    end

    def update_payloads
      payloads = []
      payloads << build_primary_payload

      updated_relations =
        @activity
        .payloads
        .where(payload_type: %w[previous_association current_association])
        .order(:relation_position)

      grouped_payloads = updated_relations.each_slice(2).to_a
      grouped_payloads.each do |grouped_payload|
        payloads << build_grouped_payload(grouped_payload)
      end

      payloads
    end

    private

    def build_primary_payload
      primary_payload = @activity.payloads.find_by(payload_type: 'primary')
      payload_attrs = payload_attrs(primary_payload)
      encryption_key = payload_key(payload_attrs)
      changed_attrs = payload_attrs.fetch('changes', [])
      changes = decrypt_change_attrs(changed_attrs, encryption_key)

      {
        owner_type: payload_attrs[:owner_type],
        primary: true,
        attrs: changes
      }
    end

    def build_grouped_payload(grouped_payload)
      updated_relations = {}

      grouped_payload.each do |payload|
        next unless payload.present?

        key = payload.payload_type.to_sym
        encryption_key = payload_key(payload)
        payload_attrs = payload_attrs(payload)
        updated_relations[key] = if encryption_key.present?
                                   decrypted_payload(payload_attrs)
                                 else
                                   obfuscated_payload(payload_attrs)
                                 end
      end

      updated_relations
    end

    def fetch_update_payloads
      updated_relations = @activity
                          .payloads
                          .where(payload_type: %w[previous_association current_association])
                          .order(:relation_position)

      grouped_by_position = updated_relations.group_by(&:relation_position)

      grouped_by_position.map do |_, payloads|
        previous_payload = payloads.find { |p| p.payload_type == 'previous_association' }
        current_payload = payloads.find { |p| p.payload_type == 'current_association' }
        [previous_payload, current_payload]
      end
    end

    def decrypt_change_attrs(change_attrs, encryption_key)
      changes = []
      change_attrs.each do |change_attr|
        decrypt_change_attr(changes, change_attr, encryption_key)
      end
      changes
    end

    def decrypt_change_attr(changes, change_attr, encryption_key)
      change_attr.each do |k, v|
        if encryption_key.nil?
          changes << { k => { from: '********', to: '********' } }
        else
          from = Loggable::Encryption.decrypt(v['from'], encryption_key)
          to = Loggable::Encryption.decrypt(v['to'], encryption_key)
          changes << { k => { from:, to: } }
        end
      end
    end

    def payloads_attrs(activity)
      activity.payloads.map do |payload|
        payload_attrs(payload)
      end
    end

    def payload_attrs(payload)
      payload
        .encoded_attrs
        .merge(
          relation_position: payload.relation_position,
          payload_type: payload.payload_type,
          owner_id: payload.owner_id,
          owner_type: payload.owner_type
        )
    end

    def payload_key(payload)
      Loggable::EncryptionKey.for_owner_by_type_and_id(payload[:owner_type], payload[:owner_id])
    end

    def owner_key
      Loggable::EncryptionKey.for_owner_by_type_and_id(owner_type, owner_id)
    end

    def actor_key
      Loggable::EncryptionKey.for_owner_by_type_and_id(actor_type, actor_id)
    end

    def actor_type
      @activity_attrs[:actor_type]
    end

    def actor_id
      @activity_attrs[:actor_id]
    end

    def owner_id
      @activity_attrs[:owner_id]
    end

    def decrypted_payload(payload_attrs)
      payload_name, encryption_key, payload_attrs = prepare_payload(payload_attrs)
      {
        owner_type: payload_name,
        attrs:
          payload_attrs.transform_values do |encoded_value|
            Loggable::Encryption.decrypt(encoded_value, encryption_key)
          end
      }
    end

    def obfuscated_payload(payload_attrs)
      payload_name, _, payload_attrs = prepare_payload(payload_attrs)
      {
        owner_type: payload_name,
        attrs: payload_attrs.transform_values! { |_| '********' }
      }
    end

    def prepare_payload(payload_attrs)
      payload_name = payload_attrs[:owner_type]
      encryption_key = payload_key(payload_attrs)
      payload_attrs.delete(:owner_id)
      payload_attrs.delete(:owner_type)
      payload_attrs.delete(:relation_position)
      payload_attrs.delete(:payload_type)
      [payload_name, encryption_key, payload_attrs]
    end
  end
end
