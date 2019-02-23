FactoryBot.define do
  factory :bloom_trade_client_order, class: "BloomTradeClient::Order" do
    incoming_amount { 0.001 }
    outgoing_amount { 182.45 }
    outgoing_currency_slug { "PHP" }
    incoming_currency_slug { "BTC" }
    price { 182448.35139997214425 }
    received_amount { 0.001 }
    status { "completed" }
  end
end
