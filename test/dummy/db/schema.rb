# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_240_707_180_147) do
  create_table 'hats', force: :cascade do |t|
    t.string 'color'
    t.integer 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_hats_on_user_id'
  end

  create_table 'loggable_activity_activities', force: :cascade do |t|
    t.string 'action'
    t.string 'actor_type'
    t.integer 'actor_id'
    t.string 'encrypted_actor_name'
    t.string 'record_type'
    t.integer 'record_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[actor_type actor_id], name: 'index_loggable_activity_activities_on_actor'
    t.index %w[record_type record_id], name: 'index_loggable_activity_activities_on_record'
  end

  create_table 'loggable_activity_data_owners', force: :cascade do |t|
    t.string 'record_type'
    t.integer 'record_id'
    t.integer 'encryption_key_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['encryption_key_id'], name: 'index_loggable_activity_data_owners_on_encryption_key_id'
    t.index %w[record_type record_id], name: 'index_loggable_activity_data_owners_on_record'
  end

  create_table 'loggable_activity_encryption_keys', force: :cascade do |t|
    t.string 'record_type'
    t.integer 'record_id'
    t.string 'secret_key'
    t.datetime 'delete_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[record_type record_id], name: 'index_loggable_activity_encryption_keys_on_record'
  end

  create_table 'loggable_activity_payloads', force: :cascade do |t|
    t.integer 'activity_id', null: false
    t.integer 'encryption_key_id', null: false
    t.string 'record_type'
    t.integer 'record_id'
    t.string 'encrypted_record_name'
    t.json 'encrypted_attrs'
    t.integer 'related_to_activity_as', default: 0
    t.boolean 'data_owner', default: false
    t.string 'route'
    t.boolean 'current_payload', default: true
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['activity_id'], name: 'index_loggable_activity_payloads_on_activity_id'
    t.index ['encryption_key_id'], name: 'index_loggable_activity_payloads_on_encryption_key_id'
    t.index %w[record_type record_id], name: 'index_loggable_activity_payloads_on_record'
  end

  create_table 'profiles', force: :cascade do |t|
    t.integer 'user_id'
    t.text 'bio'
    t.string 'profile_picture_url'
    t.string 'location'
    t.date 'date_of_birth'
    t.string 'phone_number'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_profiles_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'first_name'
    t.string 'last_name'
    t.string 'email', default: '', null: false
    t.integer 'age', default: 37, null: false
    t.string 'user_type', default: 'customer', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
  end

  add_foreign_key 'hats', 'users'
  add_foreign_key 'loggable_activity_data_owners', 'loggable_activity_encryption_keys', column: 'encryption_key_id'
  add_foreign_key 'loggable_activity_payloads', 'loggable_activity_activities', column: 'activity_id'
  add_foreign_key 'loggable_activity_payloads', 'loggable_activity_encryption_keys', column: 'encryption_key_id'
  add_foreign_key 'profiles', 'users'
end
