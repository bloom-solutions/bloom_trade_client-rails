require "addressable"
require 'api_client_base'
require 'light-service'
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
    client = MessageBus::Client.new(BloomRates.configuration.host)
    current_last_id = BloomRates::MessageBusLastIdSetter.()

    client.subscribe(channel, current_last_id) do |payload, last_id|
      BloomRates::ExchangeRates::Sync.(payload)
      BloomRates::MessageBusLastId.create_or_update(last_id: last_id)
    end

    client.start
  end

  def self.convert(base_currency:, counter_currency:, type:)
    BloomRates::ExchangeRates::Convert.(
      base_currency: base_currency,
      counter_currency: counter_currency,
      type: type
    )
  end
end
