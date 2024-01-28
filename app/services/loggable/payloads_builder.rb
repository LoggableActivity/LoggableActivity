module Loggable
  module PayloadsBuilder
    def log_activity
      Loggable::Activity.create!(
        encoded_actor_display_name: encoded_actor_name,
        encoded_record_display_name: encoded_record_name,
        action: action_key,
        actor: @actor,
        record: @record,
        payloads: build_payloads
      )
    end

    def build_payloads
      build_primary_payload 
      self.class.relations.each do |relation|
        build_relation_payload(relation)
      end
      @payloads
    end

    def build_primary_payload
      encrypted_attrs = encrypted_attrs(self.attributes, self.class.loggable_attrs, primary_encryption_key)
      @payloads << Loggable::Payload.new(
        record: @record, 
        payload_type: 'primary_payload',
        encrypted_attrs: encrypted_attrs
      )
    end

    def build_relation_payload(relation)
      relation.each do |key, value|
        case key
        when :has_one
        when :has_many
        when 'belongs_to'
          payload = build_belongs_to_payload(relation)
          @payloads << payload unless payload.nil?
        end
      end
    end

    def build_belongs_to_payload(relation)
      associated_record = self.send(relation['belongs_to'])
      return nil if associated_record.nil?
      associated_loggable_attrs = relation['loggable_attrs']

      encryption_key = associated_record_encryption_key(associated_record)
      encrypted_attrs = 
        encrypted_attrs(associated_record.attributes, associated_loggable_attrs, encryption_key) 

       Loggable::Payload.new(
          record: associated_record, 
          encrypted_attrs: encrypted_attrs,
          payload_type: 'current_association'
        )
      if relation['data_owner']
        add_enctyption_key_to_data_owner(associated_record, encryption_key)
      end
    end

    def add_enctyption_key_to_data_owner(associated_record, encryption_key)
      ap 'add_enctyption_key_to_data_owner'
      ap @record
      ap associated_record 
    end

    def associated_record_encryption_key(record)
      Loggable::EncryptionKey.for_record(record)
    end

    def encrypted_attrs(attrs, loggable_attrs, key)
      attrs = attrs.slice(*loggable_attrs)
      encrypt_attrs(attrs, key)
    end

    # def encode_attr(attr, record)
    #   # key = encryption_key(record.class.name, record.id)
    #   # key = Loggable::EncryptionKey.for_record(record)
    #   encode(attr, record, key)
    # end

    def encrypt_attrs(attrs, key)
      attrs.each do |key, value|
        attrs[key] = Loggable::Encryption.encrypt(value, key) 
      end
    end

  end
end