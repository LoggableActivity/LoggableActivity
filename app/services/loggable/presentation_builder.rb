module Loggable
  class PresentationBuilder

    def initialize(activity)
      @activity = activity
    end

    def attrs 
      update? ? get_update_attrs : get_attrs
    end

    private

    def get_attrs
      payloads.flat_map(&:attrs)
    end

    def get_update_attrs
      {
        primary: payloads.find_by(payload_type: 'primary').update_attrs,
        relations: get_relation_update_attrs
      }
    end

    def get_relation_update_attrs
      previous_associations = payloads.where(payload_type: 'previous_association')
      current_associations = payloads.where(payload_type: 'current_association')
      return [] if previous_associations.empty? && current_associations.empty?

      # if previous_associations.count == current_associations.count
      #   update_relations_attrs(previous_associations, current_associations)
      # elsif previous_associations.count > current_associations.count
      #   add_relations_attrs(previous_associations, current_associations)
      # elsif previous_associations.count < current_associations.count
      #   remove_relations_attrs(previous_associations, current_associations)
      # end
      

      [
        {
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

    def add_relations_attrs(previous_associations, current_associations)
    end

    def remove_relations_attrs(previous_associations, current_associations)
    end

    def changes(previous_associations, current_associations) 
      previous_attrs = previous_associations.attrs[:attrs]
      current_attrs = current_associations.attrs[:attrs]
      changes = []
      previous_attrs.each_with_index do |attr, index|
        current_attr = current_attrs[index]
        attr.each do |key, value|
          changes << { key => { from: value, to: current_attr[key] }}
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