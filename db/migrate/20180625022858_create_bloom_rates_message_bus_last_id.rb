class CreateBloomRatesMessageBusLastId < ActiveRecord::Migration[5.2]
  def change
    create_table :bloom_rates_message_bus_last_ids do |t|
      t.integer :last_id
      t.timestamps
    end
  end
end
