# frozen_string_literal: true

module Loggable
  module LogUpdate
    def log_update_activity
      log(:update) if self.class.auto_log.include?('update')
    end

    def log_update(activity)
      @payloads = [Loggable::Payload.new(owner: @owner, name: self.class.name, encoded_attrs: update_attrs)]
      log_associations_updates

      Loggable::Activity.create!(
        action: action(activity),
        actor: @actor,
        loggable: @owner,
        payloads: @payloads
      )
    end

    def log_associations_updates
      previous_values = @owner.saved_changes.transform_values(&:first)
      current_values = @owner.saved_changes.transform_values(&:last)

      @owner.class.reflect_on_all_associations(:belongs_to).each do |association|
        log_association_update(association, previous_values, current_values)
      end
    end

    def log_association_update(association, previous_values, current_values)
      association_key = association.foreign_key

      current_fk_value = current_values[association_key]
      previous_fk_value = previous_values[association_key]

      return unless previous_fk_value && current_fk_value != previous_fk_value

      loggable_attrs = find_loggable_attrs_for_association(association)

      relation_position = 0
      create_and_add_payload(association, previous_fk_value, :previous_association, loggable_attrs, relation_position)
      relation_position += 1
      create_and_add_payload(association, current_fk_value, :current_association, loggable_attrs, relation_position)
    end

    def create_and_add_payload(association, fk_value, payload_type, loggable_attrs, relation_position = 0)
      associated_object = association.klass.find_by(id: fk_value)
      return unless associated_object

      attrs = attrs_to_log(loggable_attrs, associated_object.attributes)
      return unless attrs.present?

      encrypt_attrs(attrs, associated_object)
      @payloads << Loggable::Payload.new(
        owner: associated_object,
        name: association.klass.name,
        encoded_attrs: attrs,
        payload_type:,
        relation_position:
      )
    end

    def find_loggable_attrs_for_association(association)
      belongs_to_relations = self.class.relations['belongs_to']
      return [] unless belongs_to_relations

      relation = belongs_to_relations.find { |hash| hash['model'] == association.klass.name }
      relation ? relation['loggable_attrs'] : []
    end
  end
end
