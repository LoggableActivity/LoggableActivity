module LoggableActivity
  # This class represents a payload in the log, containing encrypted data of one record in the database.
  # When the record is deleted, the encryption key for the payload is also deleted.
  # Payloads come in different types, each serving a specific purpose.
  class Payload < ActiveRecord::Base
    self.table_name = 'loggable_payloads'

    # Associations
    belongs_to :activity
    belongs_to :record, polymorphic: true, optional: true

    # Validations
    validates :encrypted_attrs, presence: true

    # Enumeration for different payload types
    enum payload_type: {
      primary_payload: 0,
      update_payload: 1,
      current_association: 2,
      previous_association: 3
    }

    # Returns the decrypted attributes of the payload based on its type.
    #
    # @return [Hash] The decrypted attributes.
    #
    # Example:
    #  payload.attrs
    #
    #  Returns:
    #  {
    #           "street" => "Machu Picchu",
    #             "city" => "Aguas Calientes",
    #          "country" => "Peru",
    #      "postal_code" => "08680"
    #  }
    #
    def attrs
      return deleted_attrs if record.nil?

      case payload_type
      when 'current_association', 'primary_payload', 'previous_association'
        decrypted_attrs
      when 'update_payload'
        decrypted_update_attrs
      end
    end

    private

    # Retrieves the encryption key for the payload.
    #
    # @return [String, nil] The encryption key.
    def payload_encryption_key
      @payload_encryption_key ||= LoggableActivity::EncryptionKey.for_record(record)&.key
    end

    # Helper method to handle deleted attributes.
    #
    # @return [Hash] The hash with deleted attributes.
    def deleted_attrs
      encrypted_attrs.transform_values! { I18n.t('loggable.activity.deleted') }
    end

    # Decrypts the 'from' and 'to' attributes in the update payload.
    #
    # @return [Array<Hash>] The array of decrypted changes.
    def decrypted_update_attrs
      encrypted_attrs['changes'].map do |change|
        decrypted_from_to_attr(change)
      end
    end

    # Decrypts 'from' and 'to' attributes.
    #
    # @param change [Hash] The change hash containing 'from' and 'to' values.
    # @return [Hash] The decrypted 'from' and 'to' values.
    def decrypted_from_to_attr(change)
      change.to_h do |key, value|
        from = decrypt_attr(value['from'])
        to = decrypt_attr(value['to'])
        [key, { from:, to: }]
      end
    end

    # Decrypts all attributes.
    #
    # @return [Hash] The decrypted attributes.
    def decrypted_attrs
      encrypted_attrs.each do |key, value|
        encrypted_attrs[key] = decrypt_attr(value)
      end
    end

    # Decrypts a single attribute.
    #
    # @param value [String] The encrypted value to decrypt.
    # @return [String] The decrypted value.
    def decrypt_attr(value)
      LoggableActivity::Encryption.decrypt(value, payload_encryption_key)
    end
  end
end
