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

ActiveRecord::Schema[7.1].define(version: 2024_02_01_114259) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "demo_addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "street"
    t.string "city"
    t.string "country"
    t.string "postal_code"
  end

  create_table "demo_clubs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "demo_address_id"
  end

  create_table "demo_journals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "state", default: 0
    t.uuid "patient_id"
    t.uuid "doctor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "demo_user_profiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "sex"
    t.string "religion"
    t.uuid "user_id"
    t.index ["user_id"], name: "index_demo_user_profiles_on_user_id"
  end

  create_table "loggable_activities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "action"
    t.string "actor_type"
    t.uuid "actor_id"
    t.string "encrypted_actor_display_name"
    t.string "encrypted_record_display_name"
    t.string "record_type"
    t.uuid "record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_type", "actor_id"], name: "index_loggable_activities_on_actor"
    t.index ["record_type", "record_id"], name: "index_loggable_activities_on_record"
  end

  create_table "loggable_encryption_keys", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "parrent_key_id"
    t.string "key"
    t.string "record_type"
    t.uuid "record_id"
    t.index ["record_type", "record_id"], name: "index_loggable_encryption_keys_on_record"
    t.index ["record_type", "record_id"], name: "index_loggable_encryption_keys_on_record_type_and_record_id"
  end

  create_table "loggable_payloads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "record_id"
    t.string "record_type"
    t.json "encrypted_attrs"
    t.integer "payload_type", default: 0
    t.boolean "data_owner", default: false
    t.uuid "activity_id"
    t.index ["activity_id"], name: "index_loggable_payloads_on_activity_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "demo_address_id"
    t.string "first_name"
    t.string "last_name"
    t.integer "age"
    t.text "bio"
    t.integer "user_type", default: 0
    t.uuid "demo_club_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "demo_clubs", "demo_addresses"
  add_foreign_key "demo_user_profiles", "users"
  add_foreign_key "loggable_payloads", "loggable_activities", column: "activity_id"
  add_foreign_key "users", "demo_addresses"
  add_foreign_key "users", "demo_clubs"
end
