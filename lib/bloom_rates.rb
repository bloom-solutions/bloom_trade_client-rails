require "addressable"
require 'api_client_base'
require 'light-service'
require "message_bus_client_worker"
require 'virtus'
require 'bloom_rates/engine'
require 'bloom_rates/client'
require 'bloom_rates/requests/get_quote_request'
require 'bloom_rates/responses/get_quote_response'

module BloomRates

  include APIClientBase::Base.module

  DEFAULT_CHANNEL = '/exchange_rates'.freeze

  with_configuration do
    has(:host, {
      classes: String,
      default: 'https://staging.trade.bloom.solutions',
    })
    has :reserve_currency, classes: String, default: 'PHP'
  end

  def self.setup(channel = DEFAULT_CHANNEL)
    current_last_id = BloomRates::MessageBusLastIdSetter.()

    host = BloomRates.configuration.host

    # Do not completely override MessageBusClientWorker config since this might
    # be used by the host application for other items. It is safe to assume,
    # however, that if the BloomTrade is listened to it's only this gem
    # that's doing so
    MessageBusClientWorker.configuration.subscriptions ||= {}
    MessageBusClientWorker.configuration.subscriptions[host] = {
      channel => {
        processor: BloomRates::ExchangeRates::Sync.to_s,
        message_id: current_last_id,
      }
    }
  end

  def self.convert(base_currency:, counter_currency:, type:)
    BloomRates::ExchangeRates::Convert.(
      base_currency: base_currency,
      counter_currency: counter_currency,
      type: type
    )
  end
end
