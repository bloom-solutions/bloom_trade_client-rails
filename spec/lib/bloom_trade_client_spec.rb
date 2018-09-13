require "spec_helper"

RSpec.describe BloomTradeClient do
  it "can be configured" do
    described_class.configure do |c|
      c.host = "https://tradewebsite.com"
      c.reserve_currency = "USD"
    end

    expect(described_class.configuration.host).to eq "https://tradewebsite.com"
    expect(described_class.configuration.reserve_currency).to eq "USD"
  end

  describe ".convert" do
    it "calls the BloomTradeClient::ExchangeRates::Convert#call" do
      expect(BloomTradeClient::ExchangeRates::Convert).to receive(:call)

      BloomTradeClient.convert(
        base_currency: "BTC", counter_currency: "PHP", type: "buy"
      )
    end
  end
end
