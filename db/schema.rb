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

ActiveRecord::Schema.define(version: 2023_03_23_221239) do

  create_table "admins", force: :cascade do |t|
    t.string "hashed_password", null: false
    t.string "email", null: false
    t.boolean "suspended", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "employees", primary_key: "employee_number", id: :string, force: :cascade do |t|
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.string "last_name_kana", null: false
    t.string "first_name_kana", null: false
    t.string "hashed_password"
    t.string "address", null: false
    t.string "telephone_number", null: false
    t.string "email", null: false
    t.integer "number_of_paid_leave", default: 0, null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.boolean "suspended", default: false, null: false
    t.boolean "tr_judge", default: false, null: false
    t.boolean "sly_judge", default: false, null: false
    t.date "tr_date"
    t.date "sly_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "prev_grant_date"
    t.date "next_grant_date", null: false
    t.boolean "granted", default: false, null: false
    t.index ["employee_number", "last_name_kana", "first_name_kana"], name: "index_emoloyees_on_employee_number_and_furigana"
    t.index ["employee_number"], name: "index_employees_on_employee_number"
    t.index ["first_name_kana"], name: "index_employees_on_first_name_kana"
    t.index ["last_name_kana", "first_name_kana"], name: "index_employees_on_last_name_kana_and_first_name_kana"
  end

  create_table "leave_requests", force: :cascade do |t|
    t.string "employee_id", null: false
    t.date "preferred_date", null: false
    t.text "reason_for_request", null: false
    t.boolean "permitted"
    t.boolean "canceled", default: false, null: false
    t.boolean "employee_canceled", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "salaries", force: :cascade do |t|
    t.string "employee_id", null: false
    t.integer "wage", null: false
    t.integer "total_hour", default: 0, null: false
    t.integer "extra_hour", default: 0, null: false
    t.integer "absent_hour", default: 0, null: false
    t.float "total_minute", default: 0.0, null: false
    t.float "extra_minute", default: 0.0, null: false
    t.float "absent_minute", default: 0.0, null: false
    t.integer "absent_days", default: 0, null: false
    t.integer "run_days", default: 0, null: false
    t.integer "used_paid_leave", default: 0, null: false
    t.integer "range_year", null: false
    t.integer "range_month", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
