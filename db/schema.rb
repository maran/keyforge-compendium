# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_05_20_072615) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "api_keys", force: :cascade do |t|
    t.string "key"
    t.string "secret"
    t.string "name"
    t.integer "requests", default: 0
    t.boolean "active", default: true
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_api_keys_on_user_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "uuid"
    t.string "title"
    t.string "house"
    t.string "card_type"
    t.string "front_image"
    t.string "text"
    t.string "traits"
    t.integer "amber"
    t.integer "power"
    t.integer "armor"
    t.string "rarity"
    t.string "flavor_text"
    t.integer "number"
    t.boolean "is_maverick", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cards_decks_count", default: 0
    t.float "a_weight"
    t.float "b_weight"
    t.float "c_weight"
    t.float "e_weight"
    t.decimal "board_efficiency_weight", precision: 6, scale: 2
    t.decimal "card_efficiency_weight", precision: 6, scale: 2
    t.decimal "hate_efficiency_weight", precision: 6, scale: 2
    t.bigint "parent_id"
    t.bigint "house_id"
    t.string "artist"
    t.float "base_score", default: 1.0
    t.bigint "expansion_id"
    t.index ["house_id"], name: "index_cards_on_house_id"
  end

  create_table "cards_decks", force: :cascade do |t|
    t.integer "deck_id"
    t.integer "card_id"
    t.integer "count"
    t.index ["card_id", "count"], name: "index_cards_decks_on_card_id_and_count"
    t.index ["card_id"], name: "index_cards_decks_on_card_id"
    t.index ["deck_id"], name: "index_cards_decks_on_deck_id"
  end

  create_table "cards_tags", id: false, force: :cascade do |t|
    t.bigint "card_id", null: false
    t.bigint "tag_id", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.text "subject"
    t.bigint "user_id"
    t.bigint "receiving_user_id"
    t.bigint "deck_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deck_id"], name: "index_conversations_on_deck_id"
    t.index ["receiving_user_id"], name: "index_conversations_on_receiving_user_id"
    t.index ["user_id"], name: "index_conversations_on_user_id"
  end

  create_table "decks", force: :cascade do |t|
    t.string "name"
    t.string "uuid"
    t.integer "power_level"
    t.integer "chains"
    t.integer "wins"
    t.integer "losses"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "a_rating"
    t.float "b_rating"
    t.float "c_rating"
    t.float "e_rating"
    t.decimal "consistency_rating", precision: 10, scale: 6
    t.integer "creature_count"
    t.integer "action_count"
    t.integer "artifact_count"
    t.integer "upgrade_count"
    t.integer "uncommon_count"
    t.integer "common_count"
    t.integer "rare_count"
    t.integer "fixed_count"
    t.integer "variant_count"
    t.integer "maverick_count"
    t.string "card_hash"
    t.string "sanitized_name"
    t.integer "sas_rating", default: 0
    t.integer "cards_rating", default: 0
    t.integer "synergy_rating", default: 0
    t.integer "anti_synergy_rating", default: 0
    t.bigint "expansion_id"
    t.index ["card_hash"], name: "index_decks_on_card_hash"
    t.index ["expansion_id"], name: "index_decks_on_expansion_id"
    t.index ["name"], name: "index_decks_on_name"
    t.index ["name"], name: "trgm_idx_decks_name", opclass: :gin_trgm_ops, using: :gin
    t.index ["sanitized_name"], name: "index_decks_on_sanitized_name", opclass: :gin_trgm_ops, using: :gin
    t.index ["sas_rating"], name: "index_decks_on_sas_rating"
    t.index ["uuid"], name: "index_decks_on_uuid"
  end

  create_table "decks_houses", force: :cascade do |t|
    t.integer "deck_id"
    t.integer "house_id"
    t.index ["deck_id"], name: "index_decks_houses_on_deck_id"
    t.index ["house_id"], name: "index_decks_houses_on_house_id"
  end

  create_table "decks_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "deck_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.text "notes"
    t.integer "reason", default: 0
    t.index ["category_id"], name: "index_decks_users_on_category_id"
    t.index ["deck_id"], name: "index_decks_users_on_deck_id"
    t.index ["user_id"], name: "index_decks_users_on_user_id"
  end

  create_table "expansions", force: :cascade do |t|
    t.string "name"
    t.string "abbr"
    t.integer "official_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "faqs", force: :cascade do |t|
    t.text "question"
    t.text "answer"
    t.bigint "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "rule_source_id"
    t.bigint "source_id"
    t.bigint "rule_id"
    t.index ["card_id"], name: "index_faqs_on_card_id"
    t.index ["rule_id"], name: "index_faqs_on_rule_id"
    t.index ["rule_source_id"], name: "index_faqs_on_rule_source_id"
    t.index ["source_id"], name: "index_faqs_on_source_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "winning_deck_id"
    t.bigint "losing_deck_id"
    t.bigint "winning_player_id"
    t.bigint "losing_player_id"
    t.string "winning_player_email"
    t.string "losing_player_email"
    t.datetime "played_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.index ["losing_deck_id"], name: "index_games_on_losing_deck_id"
    t.index ["losing_player_id"], name: "index_games_on_losing_player_id"
    t.index ["user_id"], name: "index_games_on_user_id"
    t.index ["winning_deck_id"], name: "index_games_on_winning_deck_id"
    t.index ["winning_player_id"], name: "index_games_on_winning_player_id"
  end

  create_table "houses", force: :cascade do |t|
    t.string "name"
    t.string "icon_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id"
    t.bigint "conversation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.string "meta_title"
    t.text "meta_description"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_blog", default: false
  end

  create_table "rules", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "slug"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sources", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "synergies", force: :cascade do |t|
    t.bigint "synergy_card_id"
    t.bigint "card_id"
    t.float "weight"
    t.bigint "synergy_reason_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_synergies_on_card_id"
    t.index ["synergy_card_id"], name: "index_synergies_on_synergy_card_id"
    t.index ["synergy_reason_id"], name: "index_synergies_on_synergy_reason_id"
  end

  create_table "synergy_reasons", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "hide_by_default", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.boolean "favourites_public", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "virtual_decks", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "deck_id"
    t.text "raw_text"
    t.string "deck_name"
    t.text "cards"
    t.boolean "ready_for_import", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deck_id"], name: "index_virtual_decks_on_deck_id"
    t.index ["user_id"], name: "index_virtual_decks_on_user_id"
  end

  add_foreign_key "api_keys", "users"
  add_foreign_key "cards", "houses"
  add_foreign_key "categories", "users"
  add_foreign_key "conversations", "users"
  add_foreign_key "conversations", "users", column: "receiving_user_id"
  add_foreign_key "decks", "expansions"
  add_foreign_key "decks_users", "categories"
  add_foreign_key "decks_users", "decks"
  add_foreign_key "decks_users", "users"
  add_foreign_key "faqs", "cards"
  add_foreign_key "faqs", "rules"
  add_foreign_key "games", "decks", column: "losing_deck_id"
  add_foreign_key "games", "decks", column: "winning_deck_id"
  add_foreign_key "games", "users"
  add_foreign_key "games", "users", column: "losing_player_id"
  add_foreign_key "games", "users", column: "winning_player_id"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "synergies", "cards"
  add_foreign_key "synergies", "synergy_reasons"
  add_foreign_key "virtual_decks", "users"
end
