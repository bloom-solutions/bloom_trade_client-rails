class CreateBloomRatesExchangeRates < ActiveRecord::Migration[5.2]
  def change
    create_table :bloom_rates_exchange_rates do |t|
      t.string :base_currency
      t.string :counter_currency
      t.decimal :buy
      t.decimal :sell
      t.decimal :mid

      t.timestamps
    end
  end
end
