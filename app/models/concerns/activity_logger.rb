# frozen_string_literal: true

module ActivityLogger
  extend ActiveSupport::Concern
  include Loggable::Attributes

  included do
    config = Loggable::Configuration.for_class(name)
    self.loggable_attrs = config&.fetch('loggable_attrs', []) || []
    self.relations = config&.fetch('relations', []) || []
    self.auto_log = config&.fetch('auto_log', []) || []

    after_create :log_create_activity
    after_update :log_update_activity
    before_destroy :log_destroy_activity
  end

  def log(activity, actor: nil, owner: nil, params: {})
    @actor = actor || Thread.current[:current_user]

    return if @actor.nil?

    @owner = owner || self
    @params = params
    case activity
    when :create, :show, :destroy
      log_activity(activity)
    when :update
      log_update(activity)
    else 
      log_custom_activity(activity)
    end
  end

  private

   def log_activity(activity)
    Loggable::Activity.create!(
      action: action(activity),
      actor: @actor,
      loggable: @owner,
      payloads: build_payloads
    )
  end

  def log_custom_activity(activity)
  end


  def log_create_activity
    log(:create) if self.class.auto_log.include?('create')
  end

  def log_update_activity
    log(:update) if self.class.auto_log.include?('update')
  end

  def log_destroy_activity
    log_destroy(:destroy) if self.class.auto_log.include?('destroy')
  end

  def log_update(activity)
    payloads = [Loggable::Payload.new(owner: @owner, name: self.class.name, encoded_attrs: update_attrs)]
    log_associations_updates(payloads)

    # payloads + associations_update
    Loggable::Activity.create!(
      action: action(activity),
      actor: @actor,
      loggable: @owner,
      payloads:
    )
  end

  def log_destroy(activity)
    payloads = [
      Loggable::Payload.new(
        owner: @owner, 
        name: self.class.name,
        encoded_attrs: {status: 'deleted'}
        )
    ]
    Loggable::EncryptionKey.delete_key_for_owner(@owner)
    Loggable::Activity.create!(
      action: action(activity),
      actor: Thread.current[:current_user] ,
      payloads:
    )
  end

  def log_associations_updates(payloads)
    previous_values = @owner.saved_changes.transform_values(&:first)
    current_values = @owner.saved_changes.transform_values(&:last)

    @owner.class.reflect_on_all_associations(:belongs_to).each do |association|
      association_key = association.foreign_key

      # Get current and previous foreign key values
      current_fk_value = current_values[association_key]
      previous_fk_value = previous_values[association_key]

      # Skip if the association didn't change
      next unless previous_fk_value && current_fk_value != previous_fk_value

      
      loggable_attrs = find_loggable_attrs_for_association(association)

      previous_associated_object = association.klass.find_by(id: previous_fk_value)
      previous_attrs = previous_associated_object.attributes
      current_associated_object = association.klass.find_by(id: current_fk_value)
      current_attrs = current_associated_object.attributes

      relation_position = 0


      if previous_associated_object 
        attrs = attrs_to_log(loggable_attrs, previous_attrs)
        if attrs.present?
          encrypt_attrs(attrs, previous_associated_object)
          payloads << Loggable::Payload.new(
            owner: previous_associated_object, 
            name: association.klass.name, 
            encoded_attrs: attrs,
            payload_type: :previous_association,
            relation_position: relation_position
            ) 
        end
      end

      if current_associated_object 
        attrs = attrs_to_log(loggable_attrs, current_attrs)
        if attrs.present?
          encrypt_attrs(attrs, current_associated_object)
          payloads << Loggable::Payload.new(
            owner: current_associated_object, 
            name: association.klass.name, 
            encoded_attrs: attrs,
            payload_type: :current_association,
            relation_position: relation_position
            ) 
        end
      end
    end
  end

  def find_loggable_attrs_for_association(association)
    belongs_to_relations = self.class.relations['belongs_to']
    return [] unless belongs_to_relations

    relation = belongs_to_relations.find { |hash| hash['model'] == association.klass.name }
    relation ? relation['loggable_attrs'] : []
  end


 

  def build_payloads
    payload_builder = Loggable::PayloadBuilder.new(@owner, @actor)
    payload_builder.build_payloads
  end

  def action(activity)
    @action ||= self.class.base_action + ".#{activity}"
  end

  class_methods do
    attr_accessor :loggable_attrs, :relations, :auto_log

    def base_action
      name.downcase.gsub('::', '/')
    end
  end
end
