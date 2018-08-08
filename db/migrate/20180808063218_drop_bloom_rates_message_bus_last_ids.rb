class DropBloomRatesMessageBusLastIds < ActiveRecord::Migration[5.2]
  def change
    drop_table "bloom_rates_message_bus_last_ids" do |t|
      t.integer "last_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
