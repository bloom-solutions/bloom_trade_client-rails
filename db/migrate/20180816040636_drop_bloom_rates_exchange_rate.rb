class DropBloomRatesExchangeRate < ActiveRecord::Migration[5.2]
  def change
    drop_table "bloom_rates_exchange_rates" do |t|
      t.string "base_currency"
      t.string "counter_currency"
      t.decimal "buy"
      t.decimal "sell"
      t.decimal "mid"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
