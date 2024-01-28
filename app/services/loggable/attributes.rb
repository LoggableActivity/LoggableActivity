# frozen_string_literal: true

module Loggable
  module Attributes
    # def encrypted_attrs(attrs, loggable_attrs, record)
    #   attrs = attrs.slice(*loggable_attrs)
    #   key = encryption_key(record)
    #   {
    #     key: key,
    #     attrs: encode(attrs, record, key)
    #   }
    # end

    # def encode_attr(attr, record)
    #   # key = encryption_key(record.class.name, record.id)
    #   key = Loggable::EncryptionKey.for_record(record)
    #   encode(attr, record, key)
    # end

    # def encoded_update_attrs(previous_values, current_values)
    #   changes = []
    #   changed_attrs = previous_values.slice(*self.class.loggable_attrs)
    #   key = Loggable::EncryptionKey.for_record(@record)
    #   changed_attrs.each do |key, from_value|
    #     from = Loggable::Encryption.encrypt(from_value, @record, key) 
    #     to_value = current_values[key]
    #     to = Loggable::Encryption.encrypt(to_value, @record, key)
    #     changes << { key => { from:, to: }}
    #   end
    #   { changes: }
    # end

    private

    # def encode(attrs, record, key)
    #   attrs.each do |key, value|
    #     attrs[key] = Loggable::Encryption.encrypt(value, record, key) 
    #   end
    # end

    def encryption_key(record)
      Loggable::EncryptionKey.for_record(record)
    end

    # def encryption_key(record_type, record_id)
    #   @encryption_key ||= Loggable::EncryptionKey.for_record_by_type_and_id(record_type, record_id)
    # end

  end
end
