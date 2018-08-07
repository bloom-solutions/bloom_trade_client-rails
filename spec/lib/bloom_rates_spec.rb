require "spec_helper"

module BloomRates
  describe "configuration defaults" do
    it "has a default host" do
      expect(BloomRates.configuration.host).
        to eq "https://staging.trade.bloom.solutions"
    end

    it "has a default reserve_currency" do
      expect(BloomRates.configuration.reserve_currency).to eq "PHP"
    end
  end

  describe ".setup" do
    it "sets up MessageBusClientWorker" do
      BloomRates::MessageBusLastId.create_or_update(last_id: 3)
      BloomRates.setup
      host = "https://staging.trade.bloom.solutions"
      subscriptions = MessageBusClientWorker.configuration.subscriptions[host]
      expect(subscriptions[BloomRates::DEFAULT_CHANNEL]).to eq({
        processor: BloomRates::ExchangeRates::Sync.to_s,
        message_id: 3,
      })
    end
  end

  describe ".convert" do
    it "calls the BloomRates::ExchangeRates::Convert#call" do
      expect(BloomRates::ExchangeRates::Convert).to receive(:call)

      BloomRates.convert(
        base_currency: "BTC", counter_currency: "PHP", type: "buy"
      )
    end
  end
end
