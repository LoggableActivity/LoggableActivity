# frozen_string_literal: true

class EnableUuidExtencion < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'pgcrypto'
  end
end
