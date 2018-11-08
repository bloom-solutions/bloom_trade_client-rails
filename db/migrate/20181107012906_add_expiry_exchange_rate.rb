class AddExpiryExchangeRate < ActiveRecord::Migration[5.2]
  def change
    add_column :bloom_trade_client_exchange_rates, :expires_at, :integer
  end
end
