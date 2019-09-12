require "spec_helper"

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
    let(:request) { double(BloomTradeClient::ConvertRequest) }

    it "calls the BloomTradeClient::ExchangeRates::Convert#call" do
      expect(BloomTradeClient::ConvertRequest).to receive(:new).with(
        base_currency: "BTC",
        counter_currency: "USD",
        request_type: "sell",
        jwt: "my-jwt",
      ).and_return(request)
      expect(request).to receive(:validate).and_return(nil)
      expect(BloomTradeClient::Convert).to receive(:call).with(request)

      BloomTradeClient.convert(
        base_currency: "BTC",
        counter_currency: "USD",
        type: "sell",
        jwt: "my-jwt",
      )
    end
  end
end
