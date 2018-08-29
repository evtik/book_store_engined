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

ActiveRecord::Schema.define(version: 20180805195530) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authors_books", id: false, force: :cascade do |t|
    t.bigint "author_id", null: false
    t.bigint "book_id", null: false
    t.index ["book_id", "author_id"], name: "index_authors_books_on_book_id_and_author_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "year"
    t.integer "width"
    t.integer "height"
    t.integer "thickness"
    t.decimal "price", precision: 5, scale: 2
    t.json "main_image"
    t.json "images"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_books_on_category_id"
  end

  create_table "books_materials", id: false, force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "material_id", null: false
    t.index ["book_id", "material_id"], name: "index_books_materials_on_book_id_and_material_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ecomm_addresses", force: :cascade do |t|
    t.integer "customer_id"
    t.integer "order_id"
    t.string "first_name"
    t.string "last_name"
    t.string "street_address"
    t.string "city"
    t.string "zip"
    t.string "country"
    t.string "phone"
    t.string "address_type"
    t.index ["customer_id"], name: "index_ecomm_addresses_on_customer_id"
    t.index ["order_id"], name: "index_ecomm_addresses_on_order_id"
  end

  create_table "ecomm_coupons", force: :cascade do |t|
    t.string "code"
    t.datetime "expires"
    t.integer "discount"
  end

  create_table "ecomm_credit_cards", force: :cascade do |t|
    t.string "number"
    t.string "cardholder"
    t.string "month_year"
    t.string "cvv"
    t.integer "order_id"
    t.index ["order_id"], name: "index_ecomm_credit_cards_on_order_id"
  end

  create_table "ecomm_line_items", force: :cascade do |t|
    t.integer "product_id"
    t.integer "order_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_ecomm_line_items_on_order_id"
    t.index ["product_id"], name: "index_ecomm_line_items_on_product_id"
  end

  create_table "ecomm_orders", force: :cascade do |t|
    t.integer "customer_id"
    t.integer "shipment_id"
    t.integer "coupon_id"
    t.string "state"
    t.decimal "subtotal", precision: 6, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coupon_id"], name: "index_ecomm_orders_on_coupon_id"
    t.index ["customer_id"], name: "index_ecomm_orders_on_customer_id"
    t.index ["shipment_id"], name: "index_ecomm_orders_on_shipment_id"
  end

  create_table "ecomm_shipments", force: :cascade do |t|
    t.string "method"
    t.integer "days_min"
    t.integer "days_max"
    t.decimal "price", precision: 5, scale: 2
  end

  create_table "materials", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "book_id"
    t.bigint "user_id"
    t.integer "score"
    t.string "title"
    t.text "body"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_reviews_on_book_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "books", "categories"
  add_foreign_key "ecomm_addresses", "ecomm_orders", column: "order_id"
  add_foreign_key "ecomm_credit_cards", "ecomm_orders", column: "order_id"
  add_foreign_key "ecomm_line_items", "ecomm_orders", column: "order_id"
  add_foreign_key "ecomm_orders", "ecomm_coupons", column: "coupon_id"
  add_foreign_key "ecomm_orders", "ecomm_shipments", column: "shipment_id"
  add_foreign_key "reviews", "books"
  add_foreign_key "reviews", "users"
end
