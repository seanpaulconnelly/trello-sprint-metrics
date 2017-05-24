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

ActiveRecord::Schema.define(version: 20170524155455) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "archived_metrics", force: :cascade do |t|
    t.bigint "sprint_id"
    t.bigint "user_id"
    t.integer "points_velocity"
    t.integer "cards_velocity"
    t.integer "unfinished_points"
    t.integer "unfinished_cards"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_archived_metrics_on_deleted_at"
    t.index ["sprint_id"], name: "index_archived_metrics_on_sprint_id"
    t.index ["user_id"], name: "index_archived_metrics_on_user_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "trello_id"
    t.integer "estimate"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "trello_card_name"
    t.bigint "list_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_cards_on_deleted_at"
    t.index ["list_id"], name: "index_cards_on_list_id"
  end

  create_table "cards_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_cards_users_on_card_id"
    t.index ["user_id"], name: "index_cards_users_on_user_id"
  end

  create_table "lists", force: :cascade do |t|
    t.string "trello_id"
    t.string "trello_list_name"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sprints", force: :cascade do |t|
    t.datetime "scheduled_starts_at"
    t.datetime "scheduled_ends_at"
    t.datetime "actual_started_at"
    t.datetime "actual_ended_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_sprints_on_deleted_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "trello_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "archived_metrics", "sprints"
  add_foreign_key "archived_metrics", "users"
  add_foreign_key "cards", "lists"
end
