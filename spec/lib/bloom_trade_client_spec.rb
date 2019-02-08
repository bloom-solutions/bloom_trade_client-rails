require "spec_helper"

class SomeCallback; end

RSpec.describe BloomTradeClient do
  let(:callback) { -> {} }

  it "can be configured" do
    described_class.configure do |c|
      c.host = "https://tradewebsite.com"
      c.reserve_currency = "USD"
      c.jwt_callback = callback
    end

    expect(described_class.configuration.host).to eq "https://tradewebsite.com"
    expect(described_class.configuration.reserve_currency).to eq "USD"
    expect(described_class.configuration.jwt_callback).to eq callback
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
