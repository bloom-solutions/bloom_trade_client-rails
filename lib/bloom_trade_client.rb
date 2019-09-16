require "addressable"
require "api_client_base"
require "light-service"
require "message_bus_client_worker"
require "virtus"

require "bloom_trade_client/engine"
require "bloom_trade_client/client"

module BloomTradeClient
  include APIClientBase::Base.module

  RATES_CHANNEL     = "/exchange_rates".freeze
  ORG_RATES_CHANNEL = "/org_exchange_rates".freeze

  with_configuration do
    has(:host, {
      classes: String,
      default: "https://trade-staging.bloom.solutions",
    })
    has :reserve_currency, classes: String, default: "PHP"
    has :jwt_callback, classes: Object
  end

  def self.convert(base_currency:, counter_currency:, type:, jwt: nil)
    request = BloomTradeClient::ConvertRequest.new(
      base_currency: base_currency,
      counter_currency: counter_currency,
      request_type: type,
      jwt: jwt,
    )
    request.validate

    BloomTradeClient::Convert.(request)
  end
end
