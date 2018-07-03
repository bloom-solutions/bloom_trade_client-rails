require "spec_helper"

module BloomRates
  RSpec.describe Client do

    let(:params) {
      {
        base_currency: "BTC",
        counter_currency: "PHP",
        quote_type: "sell",
        amount: 1.5,
      }
    }

    let(:body) do
      {
        base_currency: "BTC",
        counter_currency: "PHP",
        amount: "5",
        price: "300000",
        total: "1500000",
        quote_type: "sell",
        expiration_timestamp: (Time.now + 5.minutes).to_i
      }
    end
    let(:mock_response) { double("api-response", body: body.to_json) }

    it "returns a quote" do
      allow(described_class).to receive(:post).and_return(mock_response)

      body = described_class.new.get_quote(params)

      expect(body["base_currency"]).to eq "BTC"
      expect(body["counter_currency"]).to eq "PHP"
      expect(body["amount"]).to eq "5"
      expect(body["price"]).to eq "300000"
      expect(body["total"]).to eq "1500000"
      expect(body["quote_type"]).to eq "sell"
    end

  end
end
