# frozen_string_literal: true

module Loggable
  module Attributes
    def attrs_to_log(loggable_attrs, attrs)
      attrs.slice(*loggable_attrs)
    end

    def encrypt_attrs(attrs, owner)
      attrs.each do |key, value|
        attrs[key] = encrypt_attr(value, owner) # if obfuscate_attrs.include?(key)
      end
    end

    def encrypt_attr(value, owner)
      Loggable::Encryption.encrypt(value, owner)
    end

    def encrypt_change_attrs(previous_values, current_values)
      changes = []
      previous_values.each do |from_key, from_value|
        from = encrypt_attr(from_value, @owner)
        to = encrypt_attr(current_values[from_key], @owner)
        changes << {
          from_key => {
            from:,
            to:
          }
        }
      end
      { changes: }
    end

    def build_payload_attributes_for_association(associated_object)
      return nil if  @owner.class.relations.empty?

      relation_attrs = find_relation_attrs(associated_object.class.name)
      return nil if relation_attrs.empty?

      payload_name = associated_object.class.name
      payload_attrs = attrs_to_log(relation_attrs, associated_object.attributes)
      encrypt_attrs(payload_attrs, associated_object)
      [payload_name, payload_attrs]
    end

    def find_relation_attrs(class_name)
      list_of_hashes = @owner.class.relations.fetch('belongs_to', [])
      relation_hash = list_of_hashes.find { |hash| hash['model'] == class_name }
      relation_hash&.fetch('loggable_attrs', nil)
    end

    def update_attrs
      previous_values = saved_changes.transform_values(&:first)
      current_values = saved_changes.transform_values(&:last)
      return [] if previous_values.empty?

      change_attrs(self.class.loggable_attrs, previous_values, current_values)
    end

    def change_attrs(loggable_attrs, previous_values, current_values)
      attrs_to_log = attrs_to_log(loggable_attrs, previous_values)
      encrypt_change_attrs(attrs_to_log, current_values)
    end
  end
end
