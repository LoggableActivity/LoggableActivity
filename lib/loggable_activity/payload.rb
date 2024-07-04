# frozen_string_literal: true

require 'active_record'

module LoggableActivity
  # This class represents a payload in the log, containing encrypted data of one record in the database.
  # When the record is deleted, the encryption key for the payload is also deleted.
  # Payloads come in different types, each serving a specific purpose.
  class Payload < ActiveRecord::Base
    self.table_name = 'payloads'
    validates :related_to_activity_as, presence: true

    # Associations
    belongs_to :activity
    belongs_to :encryption_key, class_name: '::LoggableActivity::EncryptionKey'
    belongs_to :record, polymorphic: true, optional: true

    # Enumeration for different payload types
    DECRYPT_ATTRS_TYPES = %w[
      primary_payload
      has_many_payload
      belongs_to_payload
      has_one_payload
      belongs_to_update_payload
      has_many_create_payload
    ].freeze

    # Enumeration for different updatepayload types
    DECRYPT_UPDATE_ATTRS_TYPES = %w[
      primary_update_payload
      has_one_update_payload
      has_many_update_payload
    ].freeze
    # Validations
    validates :encrypted_attrs, presence: true

    # Enumeration for different payload relation types
    enum related_to_activity_as: {
      primary_payload: 0,
      has_one_payload: 1,
      belongs_to_payload: 2,
      has_many_payload: 3,
      primary_destroy_payload: 4,
      primary_update_payload: 5,
      has_one_update_payload: 6,
      has_many_update_payload: 7,
      has_many_create_payload: 8,
      belongs_to_update_payload: 9,
      belongs_to_destroy_payload: 10,
      has_one_destroy_payload: 11,
      has_many_destroy_payload: 12
    }

    # Returns the decrypted attrs.
    #
    # @return [Hash] The decrypted attributes.
    #
    # Example:
    #  payload.attrs
    #
    #  Returns:
    #  { "street" => "Machu Picchu", "city" => "Cusco" }
    #
    def attrs
      return deleted_attrs if record.nil?

      case related_to_activity_as
      when *DECRYPT_ATTRS_TYPES
        decrypted_attrs
      when *DECRYPT_UPDATE_ATTRS_TYPES
        decrypted_update_attrs
      else
        {}
      end
    end

    # Returns the route for the payload unless the encryption_key is deleted.
    #
    # Example:
    #   payload.payload_route
    #
    # @return [String] The route for the payload.
    def payload_route
      return '' if deleted?

      route
    end

    # Returns the display name for the record.
    #
    # Example:
    #   payload.record_display_name
    #
    # @return [String] The display name for the record.
    def record_display_name
      return I18n.t('loggable_activity.activity.deleted') if deleted?

      ::LoggableActivity::Encryption.decrypt(encrypted_record_name, secret_key)
    end

    # Check if the record has been deleted.
    #
    # @return [Boolean] True if the record has been deleted.
    def deleted?
      encryption_key.deleted?
    end

    private

    # Retrieves the encryption key for the payload.
    #
    # @return [String, nil] The encryption key.
    def secret_key
      encryption_key.secret_key
    end

    # Helper method to handle deleted attributes.
    #
    # @return [Hash] The hash with deleted attributes.
    def deleted_attrs
      encrypted_attrs.transform_keys(&:to_sym).transform_values! { I18n.t('loggable_activity.activity.deleted') }
    end

    # Decrypts the 'from' and 'to' attributes in the update payload.
    #
    # @return [Array<Hash>] The array of decrypted changes.
    def decrypted_update_attrs
      # return encrypted_attrs
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
        [key.to_sym, { from:, to: }]
      end
    end

    # Decrypts all attributes.
    #
    # @return [Hash] The decrypted attributes.
    def decrypted_attrs
      encrypted_attrs.transform_keys(&:to_sym).transform_values { |value| decrypt_attr(value) }
    end

    # Decrypts a single attribute.
    #
    # @param value [String] The encrypted value to decrypt.
    # @return [String] The decrypted value.
    def decrypt_attr(value)
      # return 'loggable_activity.attr.deleted' if secret_key.nil?
      ::LoggableActivity::Encryption.decrypt(value, secret_key)
    end
  end
end
