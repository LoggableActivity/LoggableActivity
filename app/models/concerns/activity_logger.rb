# frozen_string_literal: true

module ActivityLogger
  extend ActiveSupport::Concern

  included do
    # Fetch configuration for the class including this module
    config = Loggable::Configuration.for_class(name)
    self.loggable_attrs = config&.fetch('loggable_attrs', []) || []
    self.obfuscate_attrs = config&.fetch('obfuscate_attrs', []) || []
    self.relations = config&.fetch('relations', []) || []
  end

  def log(activity, actor, owner = nil)
    owner ||= self
    if activity == :update
      log_update(activity, actor, owner)
    else
      log_activity(activity, actor, owner)
    end
  end

  def obfucate(owner); end

  private

  def log_update(actor); end

  def log_activity(activity, actor, owner)
    Loggable::Activity.create!(
      action: action(activity),
      actor:,
      payloads: build_payloads(owner)
    )
  end

  def build_payloads(owner)
    payloads = []
    add_payload_for_self(payloads, owner)
    add_payloads_for_associations(payloads, owner)
    payloads
  end

  def add_payload_for_self(payloads, owner)
    # payload_name = self.class.name.downcase.gsub('::', '_')
    self.class.name
    payload_attrs = attrs_to_log(self.class.loggable_attrs, attributes)
    encrypt_attrs(payload_attrs, owner)
    payloads << Loggable::Payload.new(owner:, name: self.class.name, attrs: payload_attrs)
  end

  def add_payloads_for_associations(payloads, owner)
    self.class.reflect_on_all_associations(:belongs_to).each do |association|
      associated_object = send(association.name)
      next unless associated_object

      payload_name, payload_attrs = build_payload_attributes_for_association(association, associated_object)
      encrypt_attrs(payload_attrs, owner)
      payloads << Loggable::Payload.new(owner:, name: payload_name, attrs: payload_attrs) if payload_attrs
    end
  end

  def build_payload_attributes_for_association(_association, associated_object)
    relation_attrs = find_relation_attrs(associated_object.class.name)
    return nil unless relation_attrs

    payload_name = associated_object.class.name
    payload_attrs = attrs_to_log(relation_attrs, associated_object.attributes)
    encrypt_attrs(payload_attrs)
    [payload_name, payload_attrs]
  end

  def find_relation_attrs(class_name)
    list_of_hashes = self.class.relations.fetch('belongs_to', [])
    relation_hash = list_of_hashes.find { |hash| hash['model'] == class_name }
    relation_hash&.fetch('loggable_attrs', nil)
  end

  def attrs_to_log(loggable_attrs, attrs)
    attrs.slice(*loggable_attrs)
  end

  def encrypt_attrs(attrs, owner = nil)
    # TODO: what to do if owner is nil?
    return attrs unless owner

    enctyption_key = Loggable::EncryptionKey.for_owner(owner)
    attrs.each do |key, value|
      attrs[key] = Loggable::Encryption.encrypt(value, enctyption_key) # if obfuscate_attrs.include?(key)
    end
  end

  def action(activity)
    @action ||= self.class.base_action + ".#{activity}"
  end

  class_methods do
    attr_accessor :loggable_attrs, :obfuscate_attrs, :relations

    def base_action
      name.downcase.gsub('::', '/')
    end
  end
end
