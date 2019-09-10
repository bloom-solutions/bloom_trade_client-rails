FactoryBot.define do
  factory(:bloom_trade_client_convert_result, {
    class: "BloomTradeClient::ConvertResult"
  }) do
    rate { 200.0 }
    state { "valid" }
    expires_at { 5.minutes.from_now }
  end
end
