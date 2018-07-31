require "spec_helper"

module BloomRates
  describe "configuration defaults" do
    it "has a default bloom_trade_url" do
      expect(BloomRates.configuration.bloom_trade_url).
        to eq "https://staging.trade.bloom.solutions"
    end

    it "has a default reserve_currency" do
      expect(BloomRates.configuration.reserve_currency).to eq "PHP"
    end
  end

  describe ".setup" do
    let(:client) { double(MessageBus::Client) }

    it "calls MessageBus.subscribe" do
      expect(MessageBus::Client).to receive(:new).with(
        "https://staging.trade.bloom.solutions"
      ).and_return(client)

      expect(client).to receive(:subscribe)
      expect(client).to receive(:start)

      BloomRates.setup
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
