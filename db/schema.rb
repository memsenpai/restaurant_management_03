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

ActiveRecord::Schema.define(version: 20170721015913) do

  create_table "bill_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "id_item"
    t.integer  "quantity"
    t.integer  "discount"
    t.integer  "price"
    t.integer  "item_type"
    t.integer  "bill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bills", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "customer_id"
    t.integer  "order_id"
    t.integer  "discount"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "category_dishes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "category_id"
    t.integer  "dish_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "combo_dishes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "combo_id"
    t.integer  "dish_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "combos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "description", limit: 65535
    t.integer  "discount"
    t.string   "name"
    t.string   "image"
    t.datetime "from"
    t.datetime "to"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "customers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone_num"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discount_codes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "code"
    t.integer  "discount"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dishes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "price"
    t.string   "image"
    t.text     "description",  limit: 65535
    t.boolean  "is_available"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "order_combos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "order_id"
    t.integer  "combo_id"
    t.integer  "discount"
    t.integer  "quantity"
    t.integer  "price"
    t.integer  "total_price"
    t.integer  "status",      default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "order_dishes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "order_id"
    t.integer  "dish_id"
    t.integer  "discount"
    t.integer  "quantity"
    t.integer  "price"
    t.integer  "total_price"
    t.integer  "status",      default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "customer_id"
    t.integer  "table_id"
    t.string   "code"
    t.date     "day"
    t.string   "time_in"
    t.boolean  "is_confirm",  default: false
    t.integer  "discount",    default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "promos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "dish_id"
    t.integer  "discount",   default: 0
    t.datetime "start_day"
    t.datetime "end_day"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "staffs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.integer  "staff_role"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_staffs_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_staffs_on_reset_password_token", unique: true, using: :btree
  end

  create_table "tables", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "capacity"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
