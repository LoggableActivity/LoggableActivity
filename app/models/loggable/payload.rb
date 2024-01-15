# frozen_string_literal: true

module Loggable
  class Payload < ApplicationRecord
    belongs_to :activity
    belongs_to :owner, polymorphic: true, optional: true
    # validates :owner, presence: true
    validates :encoded_attrs, presence: true
    enum payload_type: { 
      primary: 'primary', 
      previous_association: 'previous_association',
      current_association: 'current_association'
    }

    def attrs 
      { name:, attrs: decoded_attrs }
    end

    def update_attrs
        {
          name: name,
          changes: decoded_changes
        }
    end

    def decoded_changes
      return { name:, attrs: [] } if encoded_attrs['changes'].empty?

      encoded_attrs['changes'].flat_map do |change|
        decode_change_attr(change)
      end
    end

    # private

    def decode_change_attr(change)
      change.map do |key, value|
        from = decode_attr(value['from'])
        to = decode_attr(value['to'])
        { key => { from:, to: } }
      end
    end

    def decoded_attrs
      encoded_attrs.map do |key, value|
        {key =>  decode_attr(value)}
      end
    end

    def decode_attr(value)
      ap owner
      Loggable::Encryption.decrypt_for(value, owner)
      # "fo"
    end
  end
end
