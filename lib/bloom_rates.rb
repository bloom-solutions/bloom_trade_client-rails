require "light-service"
require "virtus"
require "gem_config"

require "bloom_rates/engine"

module BloomRates
  include GemConfig::Base

  with_configuration do
    has :publisher_url, classes: String, default: "https://trade.bloom.solutions"
    has :reserve_currency, classes: String, default: "PHP"
  end

  def self.setup(channel:)
    client = MessageBus::Client.new(BloomRates.configuration.publisher_url)

    client.subscribe(channel) do |payload|
      ExchangeRates::Sync.(payload)
    end

    client.start
  end
end
