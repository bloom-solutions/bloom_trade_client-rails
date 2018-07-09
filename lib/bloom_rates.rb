require 'light-service'
require 'virtus'
require 'gem_config'
require 'bloom_rates/engine'
require 'httparty'

module BloomRates
  include GemConfig::Base

  DEFAULT_CHANNEL = '/exchange_rates'.freeze

  with_configuration do
    has :bloom_trade_url, classes: String, default: 'https://trade.bloom.solutions'
    has :reserve_currency, classes: String, default: 'PHP'
    has :bloom_trade_api_token, classes: String
  end

  def self.setup(channel = DEFAULT_CHANNEL)
    client = MessageBus::Client.new(BloomRates.configuration.bloom_trade_url)
    last_id = BloomRates::MessageBusLastIdSetter.()

    client.subscribe(channel, last_id) do |payload, last_id|
      BloomRates::ExchangeRates::Sync.(payload)
      BloomRates::MessageBusLastId.create!(last_id: last_id)
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
