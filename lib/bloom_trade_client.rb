require "addressable"
require 'api_client_base'
require 'light-service'
require "message_bus_client_worker"
require 'virtus'

require 'bloom_trade_client/engine'
require 'bloom_trade_client/client'
require 'bloom_trade_client/requests/base_authenticated_request'
require 'bloom_trade_client/requests/get_quote_request'
require 'bloom_trade_client/requests/update_quote_request'
require 'bloom_trade_client/responses/base_response'
require 'bloom_trade_client/responses/get_quote_response'
require 'bloom_trade_client/responses/update_quote_response'

module BloomTradeClient

  include APIClientBase::Base.module

  RATES_CHANNEL     = '/exchange_rates'.freeze
  ORG_RATES_CHANNEL = '/org_exchange_rates'.freeze

  with_configuration do
    has(:host, {
      classes: String,
      default: 'https://staging.trade.bloom.solutions',
    })
    has :reserve_currency, classes: String, default: 'PHP'
    has :jwt_callback, classes: Object
  end

  def self.convert(base_currency:, counter_currency:, type:, jwt: nil)
    BloomTradeClient::ExchangeRates::Convert.(
      base_currency: base_currency,
      counter_currency: counter_currency,
      type: type,
      jwt: jwt
    )
  end
end
