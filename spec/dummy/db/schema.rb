# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_02_08_051452) do

  create_table "bloom_trade_client_exchange_rates", force: :cascade do |t|
    t.string "base_currency"
    t.string "counter_currency"
    t.decimal "buy"
    t.decimal "sell"
    t.decimal "mid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "expires_at"
    t.string "jwt_hash"
    t.index ["buy", "sell", "jwt_hash"], name: "by_buy_sell_jwt_hash"
  end

end
