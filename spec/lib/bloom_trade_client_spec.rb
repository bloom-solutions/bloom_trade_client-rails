require "spec_helper"

RSpec.describe BloomRates do
  it "can be configured" do
    described_class.configure do |c|
      c.host = "https://tradewebsite.com"
      c.reserve_currency = "USD"
    end

    expect(described_class.configuration.host).to eq "https://tradewebsite.com"
    expect(described_class.configuration.reserve_currency).to eq "USD"
    subscription_config = MessageBusClientWorker.configuration.
      subscriptions["https://tradewebsite.com"]\
      [described_class::DEFAULT_CHANNEL]
    expect(subscription_config[:processor]).
      to eq BloomRates::ExchangeRates::Sync.to_s
    expect(subscription_config[:message_id]).to eq 0
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
