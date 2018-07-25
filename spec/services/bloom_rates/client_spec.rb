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

    before do
      BloomRates.configure do |c|
        c.bloom_trade_url = "https://staging.trade.bloom.solutions"
      end
    end

    it "returns a quote", vcr: {record: :once} do
      response = described_class.new.
        get_quote(CONFIG[:bloom_trade_api_token], params)
      body = JSON.parse(response.body)

      expect(response).to be_success
      expect(body["base_currency"]).to eq "BTC"
      expect(body["counter_currency"]).to eq "PHP"
      expect(body["quote_type"]).to eq "sell"
      expect(body["amount"]).to eq "1.5"
      expect(body["price"]).to be_present
      expect(body["total"]).to be_present
      expect(body["bx8_fee"]).to be_present
      expect(body["memo"]).to be_present
      expect(body["expiration_timestamp"]).to_not be_nil
    end

  end
end
