# frozen_string_literal: true

module Loggable
  class PayloadBuilder
    include Loggable::Attributes
    def initialize(owner, actor)
      @actor = actor
      @owner = owner
      @loggable_attrs = owner.class.loggable_attrs
      @attributes = owner.attributes
    end

    def build_payloads
      payloads = []
      build_payload_for_owner(payloads)
      build_payloads_for_associations(payloads)
      payloads
    end

    private

    def build_payload_for_owner(payloads)
      payload_attrs = attrs_to_log(@loggable_attrs, @attributes)
      encrypt_attrs(payload_attrs, @owner)
      payloads << Loggable::Payload.new(owner: @owner, name: @owner.class.name, encoded_attrs: payload_attrs)
    end

    def build_payloads_for_associations(payloads)
      associated_objects.each do |associated_object|
        payload_name, payload_attrs = build_payload_attributes_for_association(associated_object)
        payloads << Loggable::Payload.new(owner: associated_object, name: payload_name, encoded_attrs: payload_attrs) if payload_attrs
      end
    end

    def associated_objects
      objects = []
      @owner.class.reflect_on_all_associations(:belongs_to).each do |association|
        associated_object = @owner.send(association.name)
        next unless associated_object
        objects << associated_object
      end
      objects
    end
  end
end
