require "addressable"
require 'api_client_base'
require 'light-service'
require "message_bus_client_worker"
require 'virtus'

require 'bloom_trade_client/engine'
require 'bloom_trade_client/client'
require 'bloom_trade_client/requests/base_authenticated_request'
require 'bloom_trade_client/requests/get_quote_request'
require 'bloom_trade_client/responses/base_response'
require 'bloom_trade_client/responses/get_quote_response'

module BloomTradeClient

  include APIClientBase::Base.module

  DEFAULT_CHANNEL = '/exchange_rates'.freeze

  with_configuration do
    has(:host, {
      classes: String,
      default: 'https://staging.trade.bloom.solutions',
    })
    has :reserve_currency, classes: String, default: 'PHP'
  end

  after_configuration_change do
    configure_message_bus_client_worker
  end

  def self.configure_message_bus_client_worker
    host = BloomTradeClient.configuration.host

    # Do not completely override MessageBusClientWorker config since this might
    # be used by the host application for other items. It is safe to assume,
    # however, that if the BloomTrade is listened to it's only this gem
    # that's doing so
    MessageBusClientWorker.configuration.subscriptions ||= {}
    MessageBusClientWorker.configuration.subscriptions[host] = {
      DEFAULT_CHANNEL => {
        processor: BloomTradeClient::ExchangeRates::Sync.to_s,
        message_id: 0,
      }
    }
  end

  def self.convert(base_currency:, counter_currency:, type:)
    BloomTradeClient::ExchangeRates::Convert.(
      base_currency: base_currency,
      counter_currency: counter_currency,
      type: type
    )
  end
end
