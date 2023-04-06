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

ActiveRecord::Schema[7.0].define(version: 2023_04_06_180636) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "inventories", force: :cascade do |t|
    t.bigint "users_id"
    t.bigint "items_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["items_id"], name: "index_inventories_on_items_id"
    t.index ["users_id"], name: "index_inventories_on_users_id"
  end

  create_table "items", force: :cascade do |t|
    t.integer "point", null: false
    t.string "kind", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mark_survivors", force: :cascade do |t|
    t.bigint "user_report_id"
    t.bigint "user_marked_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_marked_id"], name: "index_mark_survivors_on_user_marked_id"
    t.index ["user_report_id", "user_marked_id"], name: "index_mark_survivors_on_user_report_id_and_user_marked_id", unique: true
    t.index ["user_report_id"], name: "index_mark_survivors_on_user_report_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "gender"
    t.string "status", default: "survivor"
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.integer "age", null: false
    t.integer "marks", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "inventories", "items", column: "items_id"
  add_foreign_key "inventories", "users", column: "users_id"
  add_foreign_key "mark_survivors", "users", column: "user_marked_id"
  add_foreign_key "mark_survivors", "users", column: "user_report_id"
end
