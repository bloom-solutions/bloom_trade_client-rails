require "addressable"
require 'api_client_base'
require 'light-service'
require 'virtus'
require 'httparty'
require 'bloom_rates/engine'
require 'bloom_rates/client'

module BloomRates

  include APIClientBase::Base.module

  DEFAULT_CHANNEL = '/exchange_rates'.freeze

  with_configuration do
    has :bloom_trade_url, classes: String, default: 'https://trade.bloom.solutions'
    has :reserve_currency, classes: String, default: 'PHP'
  end

  def self.setup(channel = DEFAULT_CHANNEL)
    client = MessageBus::Client.new(BloomRates.configuration.bloom_trade_url)
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
