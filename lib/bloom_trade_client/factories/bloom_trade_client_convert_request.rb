FactoryBot.define do
  factory(:bloom_trade_client_convert_request, {
    class: "BloomTradeClient::ConvertRequest",
  }) do
    base_currency { "BTC" }
    counter_currency { "PHP" }
    request_type { "mid" }
    jwt { "ASDFTEST" }
    reserve_currency { "USD" }
  end
end
