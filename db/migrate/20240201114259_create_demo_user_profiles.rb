# frozen_string_literal: true

class CreateDemoUserProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :demo_user_profiles, id: :uuid do |t|
      t.string :sex
      t.string :religion
      # t.references :user, binary: true, null: false, foreign_key: true, type: :uuid
      t.references :user, type: :uuid, foreign_key: true
    end
  end
end
