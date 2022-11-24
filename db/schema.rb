# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
<<<<<<< HEAD
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_02_09_094148) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
=======
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_10_25_184305) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

<<<<<<< HEAD
  create_table "active_storage_blobs", force: :cascade do |t|
=======
  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
<<<<<<< HEAD
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
=======
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

<<<<<<< HEAD
  create_table "features", force: :cascade do |t|
    t.integer "setting_id"
    t.string "name", null: false
    t.string "value"
    t.boolean "enabled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_features_on_name"
    t.index ["setting_id"], name: "index_features_on_setting_id"
=======
  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "formats", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "recording_id"
    t.string "recording_type", null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recording_id"], name: "index_formats_on_recording_id"
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
  end

  create_table "invitations", force: :cascade do |t|
    t.string "email", null: false
    t.string "provider", null: false
<<<<<<< HEAD
    t.string "invite_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invite_token"], name: "index_invitations_on_invite_token"
    t.index ["provider"], name: "index_invitations_on_provider"
  end

  create_table "role_permissions", force: :cascade do |t|
    t.string "name"
    t.string "value", default: ""
    t.boolean "enabled", default: false
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_role_permissions_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.integer "priority", default: 9999
    t.boolean "can_create_rooms", default: false
    t.boolean "send_promoted_email", default: false
    t.boolean "send_demoted_email", default: false
    t.boolean "can_edit_site_settings", default: false
    t.boolean "can_edit_roles", default: false
    t.boolean "can_manage_users", default: false
    t.string "colour"
    t.string "provider"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "provider"], name: "index_roles_on_name_and_provider", unique: true
    t.index ["name"], name: "index_roles_on_name"
    t.index ["priority", "provider"], name: "index_roles_on_priority_and_provider", unique: true
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "uid"
    t.string "bbb_id"
    t.integer "sessions", default: 0
    t.datetime "last_session"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "room_settings", default: "{ }"
    t.string "moderator_pw"
    t.string "attendee_pw"
    t.string "access_code"
    t.boolean "deleted", default: false, null: false
    t.string "moderator_access_code"
    t.index ["bbb_id"], name: "index_rooms_on_bbb_id"
    t.index ["deleted"], name: "index_rooms_on_deleted"
    t.index ["last_session"], name: "index_rooms_on_last_session"
    t.index ["name"], name: "index_rooms_on_name"
    t.index ["sessions"], name: "index_rooms_on_sessions"
    t.index ["uid"], name: "index_rooms_on_uid"
    t.index ["user_id"], name: "index_rooms_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "provider", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider"], name: "index_settings_on_provider"
  end

  create_table "shared_accesses", force: :cascade do |t|
    t.integer "room_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_shared_accesses_on_room_id"
    t.index ["user_id"], name: "index_shared_accesses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "room_id"
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "username"
    t.string "email"
    t.string "social_uid"
    t.string "image"
    t.string "password_digest"
    t.boolean "accepted_terms", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "email_verified", default: false
    t.string "language", default: "default"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "activation_digest"
    t.datetime "activated_at"
    t.boolean "deleted", default: false, null: false
    t.integer "role_id"
    t.datetime "last_login"
    t.integer "failed_attempts"
    t.datetime "last_failed_attempt"
    t.index ["created_at"], name: "index_users_on_created_at"
    t.index ["deleted"], name: "index_users_on_deleted"
    t.index ["email"], name: "index_users_on_email"
    t.index ["password_digest"], name: "index_users_on_password_digest", unique: true
    t.index ["provider"], name: "index_users_on_provider"
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["room_id"], name: "index_users_on_room_id"
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

=======
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email", "provider"], name: "index_invitations_on_email_and_provider", unique: true
    t.index ["token"], name: "index_invitations_on_token", unique: true
  end

  create_table "meeting_options", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "default_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_meeting_options_on_name", unique: true
  end

  create_table "permissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recordings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "room_id"
    t.string "name", null: false
    t.string "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "visibility", null: false
    t.integer "length", null: false
    t.integer "participants", null: false
    t.boolean "protectable"
    t.index ["room_id"], name: "index_recordings_on_room_id"
  end

  create_table "role_permissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "role_id"
    t.uuid "permission_id"
    t.string "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_role_permissions_on_permission_id"
    t.index ["role_id"], name: "index_role_permissions_on_role_id"
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "color", default: "", null: false
    t.string "provider", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "provider"], name: "index_roles_on_name_and_provider", unique: true
  end

  create_table "room_meeting_options", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "room_id"
    t.uuid "meeting_option_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meeting_option_id"], name: "index_room_meeting_options_on_meeting_option_id"
    t.index ["room_id"], name: "index_room_meeting_options_on_room_id"
  end

  create_table "rooms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.string "name", null: false
    t.string "friendly_id", null: false
    t.string "meeting_id", null: false
    t.datetime "last_session"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recordings_processing", default: 0
    t.boolean "online", default: false
    t.index ["friendly_id"], name: "index_rooms_on_friendly_id", unique: true
    t.index ["meeting_id"], name: "index_rooms_on_meeting_id", unique: true
    t.index ["user_id"], name: "index_rooms_on_user_id"
  end

  create_table "rooms_configurations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "meeting_option_id"
    t.string "provider", null: false
    t.string "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meeting_option_id", "provider"], name: "index_rooms_configurations_on_meeting_option_id_and_provider", unique: true
    t.index ["meeting_option_id"], name: "index_rooms_configurations_on_meeting_option_id"
  end

  create_table "settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_settings_on_name", unique: true
  end

  create_table "shared_accesses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_shared_accesses_on_room_id"
    t.index ["user_id", "room_id"], name: "index_shared_accesses_on_user_id_and_room_id", unique: true
    t.index ["user_id"], name: "index_shared_accesses_on_user_id"
  end

  create_table "site_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "setting_id"
    t.string "value", null: false
    t.string "provider", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["setting_id"], name: "index_site_settings_on_setting_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "external_id"
    t.string "provider", null: false
    t.string "password_digest"
    t.datetime "last_login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "role_id"
    t.string "language", null: false
    t.string "reset_digest"
    t.datetime "reset_sent_at", precision: nil
    t.boolean "verified", default: false
    t.string "verification_digest"
    t.datetime "verification_sent_at", precision: nil
    t.string "session_token"
    t.datetime "session_expiry", precision: nil
    t.integer "status", default: 0
    t.index ["email", "provider"], name: "index_users_on_email_and_provider", unique: true
    t.index ["reset_digest"], name: "index_users_on_reset_digest", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["session_token"], name: "index_users_on_session_token", unique: true
    t.index ["verification_digest"], name: "index_users_on_verification_digest", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "formats", "recordings"
  add_foreign_key "recordings", "rooms"
  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "role_permissions", "roles"
  add_foreign_key "room_meeting_options", "meeting_options"
  add_foreign_key "room_meeting_options", "rooms"
  add_foreign_key "rooms", "users"
  add_foreign_key "rooms_configurations", "meeting_options"
  add_foreign_key "shared_accesses", "rooms"
  add_foreign_key "shared_accesses", "users"
  add_foreign_key "site_settings", "settings"
  add_foreign_key "users", "roles"
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
end
