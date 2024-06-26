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

ActiveRecord::Schema[7.0].define(version: 2024_01_29_175426) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "complaints", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "telegram_id"
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "status", default: "filling_by_user"
    t.string "photos_dir_path"
    t.text "complaint_text"
    t.integer "photos_amount"
    t.boolean "is_proofed_by_forwarted_mes"
    t.string "telegraph_link"
    t.text "explanation_by_moderator"
    t.string "photo_urls_remote_tmp", array: true
    t.string "mes_id_published_in_channel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "handled_moderator_id"
    t.json "media_data", default: {"texts"=>[], "voice_file_ids"=>[], "video_note_file_ids"=>[]}
    t.string "photo_file_ids", array: true
    t.string "userbot_session"
    t.string "private_channel_telegram_id"
    t.index ["user_id"], name: "index_complaints_on_user_id"
  end

  create_table "configs", force: :cascade do |t|
    t.string "for_private_channel_video_file_ids", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "counters", force: :cascade do |t|
    t.integer "lookup_requests_from_bots", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "moderators", force: :cascade do |t|
    t.string "telegram_id"
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "lg"
    t.string "state_aasm"
    t.string "cur_complaint_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "access_amount", default: 0
    t.integer "reject_amount", default: 0
    t.integer "block_amount", default: 0
    t.integer "decisions_per_day_amount", default: 0
    t.string "status", default: "active"
    t.string "chat_member_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "telegram_id"
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "lg"
    t.string "state_aasm"
    t.string "cur_complaint_id"
    t.string "cur_message_id"
    t.string "status"
    t.string "complaint_id"
    t.text "justification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date_when_became_a_scamer"
    t.string "chat_member_status"
    t.string "managed_status_by"
  end

  create_table "videos", force: :cascade do |t|
    t.json "oracles_tips"
    t.json "lookup_the_counterparty"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "compare_user_id"
    t.json "option_details"
    t.json "search_user"
    t.json "complaint_text"
    t.json "input_username"
    t.json "complaint_photos"
    t.json "start"
  end

  add_foreign_key "complaints", "users"
end
