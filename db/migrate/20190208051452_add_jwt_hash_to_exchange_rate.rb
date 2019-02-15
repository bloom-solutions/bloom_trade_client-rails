class AddJwtHashToExchangeRate < ActiveRecord::Migration[5.2]
  def change
    add_column :bloom_trade_client_exchange_rates, :jwt_hash, :string
    add_index :bloom_trade_client_exchange_rates, [:buy, :sell, :jwt_hash], name: "by_buy_sell_jwt_hash"
  end
end
