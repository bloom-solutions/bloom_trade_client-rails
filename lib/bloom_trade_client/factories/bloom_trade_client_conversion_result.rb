FactoryBot.define do

  factory(:bloom_trade_client_conversion_result, {
    class: "BloomTradeClient::ConversionResult"
  }) do

    rate { 200.0 }
    expires_at { 5.minutes.from_now }

  end

end
