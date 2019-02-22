FactoryBot.define do
  factory :bloom_trade_client_exchange_rate, class: "BloomTradeClient::ExchangeRate" do
    expires_at { 2.days.from_now }
  end
end
