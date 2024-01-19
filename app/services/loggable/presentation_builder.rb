# frozen_string_literal: true

module Loggable
  class PresentationBuilder
    def initialize(activity)
      @activity = activity
    end

    def attrs
      update? ? fetch_update_attrs : fetch_attrs
    end

    private

    def fetch_attrs
      # @fetch_attrs ||= payloads.flat_map(&:attrs)
      @fetch_attrs ||=
        {
          owner_type: @activity.loggable_type,
          primary_attrs: payloads.find_by(payload_type: 'primary').attrs,
          relations: fetch_relation_attrs
        }
    end

    def fetch_relation_attrs
      @activity.payloads.where.not(payload_type: 'primary').map(&:attrs)
    end

    def fetch_update_attrs
      @fetch_update_attrs ||=
        {
          owner_type: @activity.loggable_type,
          primary: payloads.find_by(payload_type: 'primary').update_attrs,
          relations: fetch_relation_update_attrs
        }
    end

    def fetch_relation_update_attrs
      previous_associations = payloads.where(payload_type: 'previous_association')
      current_associations = payloads.where(payload_type: 'current_association')
      return [] if previous_associations.empty? && current_associations.empty?

      [
        {
          owner_type: @activity.loggable_type,
          name: current_associations.first.name,
          changes: changes(previous_associations.first, current_associations.first)
        }
      ]
    end

    def update_relations_attrs(previous_associations, current_associations)
      # previous_associations.map! do |previous_association|
      # {
      #   #   name: previous_association.name,
      #   #   changes: changes(previous_association, current_associations.find_by(name: previous_association.name))
      #   # }
      # end
    end

    def add_relations_attrs(previous_associations, current_associations); end

    def remove_relations_attrs(previous_associations, current_associations); end

    def changes(previous_associations, current_associations)
      previous_attrs = previous_associations.attrs[:attrs]
      current_attrs = current_associations.attrs[:attrs]
      changes = []
      previous_attrs.each_with_index do |attr, index|
        current_attr = current_attrs[index]
        attr.each do |key, value|
          changes << { key => { from: value, to: current_attr[key] } }
        end
      end
      changes
    end

    def update?
      @activity.action.ends_with?('update')
    end

    def activity_type
      @activity.action.split('.').last
    end

    def payloads
      @activity.payloads
    end
  end
end
