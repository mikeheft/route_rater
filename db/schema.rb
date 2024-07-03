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

ActiveRecord::Schema[7.1].define(version: 2024_07_02_210854) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "line_1", null: false
    t.string "line_2"
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip_code", null: false
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.string "place_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city", "state"], name: "index_addresses_on_city_and_state"
    t.index ["line_1", "line_2", "zip_code"], name: "index_addresses_on_line_1_and_line_2_and_zip_code", unique: true
    t.index ["place_id"], name: "index_addresses_on_place_id", unique: true
    t.index ["state"], name: "index_addresses_on_state"
    t.index ["zip_code"], name: "index_addresses_on_zip_code"
  end

  create_table "driver_addresses", force: :cascade do |t|
    t.boolean "current", default: false, null: false
    t.bigint "driver_id", null: false
    t.bigint "address_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_driver_addresses_on_address_id"
    t.index ["current", "driver_id"], name: "index_driver_addresses_on_current_and_driver_id", unique: true, where: "(current IS TRUE)"
    t.index ["driver_id"], name: "index_driver_addresses_on_driver_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rides", force: :cascade do |t|
    t.float "duration"
    t.float "distance"
    t.float "commute_duration"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.bigint "driver_id"
    t.bigint "from_address_id", null: false
    t.bigint "to_address_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commute_duration"], name: "index_rides_on_commute_duration"
    t.index ["distance"], name: "index_rides_on_distance"
    t.index ["driver_id"], name: "index_rides_on_driver_id"
    t.index ["duration"], name: "index_rides_on_duration"
    t.index ["from_address_id"], name: "index_rides_on_from_address_id"
    t.index ["to_address_id"], name: "index_rides_on_to_address_id"
  end

  add_foreign_key "driver_addresses", "addresses"
  add_foreign_key "driver_addresses", "drivers"
  add_foreign_key "rides", "addresses", column: "from_address_id"
  add_foreign_key "rides", "addresses", column: "to_address_id"
end
