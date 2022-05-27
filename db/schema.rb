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

ActiveRecord::Schema[7.0].define(version: 2022_05_27_005723) do
  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "surname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "items", force: :cascade do |t|
    t.string "sku"
    t.integer "height"
    t.integer "width"
    t.integer "length"
    t.integer "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "min_shipping_prices", force: :cascade do |t|
    t.integer "start_distance"
    t.integer "end_distance"
    t.decimal "price"
    t.integer "shipping_company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shipping_company_id"], name: "index_min_shipping_prices_on_shipping_company_id"
  end

  create_table "shipping_companies", force: :cascade do |t|
    t.string "registration_number"
    t.string "corporate_name"
    t.string "brand_name"
    t.string "email"
    t.string "street_name"
    t.string "street_number"
    t.string "complement"
    t.string "district"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.integer "status", default: 5
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipping_deadlines", force: :cascade do |t|
    t.integer "start_distance"
    t.integer "end_distance"
    t.integer "deadline"
    t.integer "shipping_company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shipping_company_id"], name: "index_shipping_deadlines_on_shipping_company_id"
  end

  create_table "shipping_prices", force: :cascade do |t|
    t.decimal "start_volume"
    t.decimal "end_volume"
    t.integer "start_weight"
    t.integer "end_weight"
    t.decimal "price_km"
    t.integer "shipping_company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shipping_company_id"], name: "index_shipping_prices_on_shipping_company_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "surname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "shipping_company_id", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["shipping_company_id"], name: "index_users_on_shipping_company_id"
  end

  add_foreign_key "min_shipping_prices", "shipping_companies"
  add_foreign_key "shipping_deadlines", "shipping_companies"
  add_foreign_key "shipping_prices", "shipping_companies"
  add_foreign_key "users", "shipping_companies"
end
