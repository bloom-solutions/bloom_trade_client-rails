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
    let(:mock_response) do
      {
        "base_currency"=>"BTC", 
        "counter_currency"=>"PHP", 
        "quote_type"=>"buy", 
        "amount"=>"100.0", 
        "price"=>"100000", 
        "total"=>"10000000", 
        "bx8_fee"=>"100",
        "memo"=>"some-random-string",
        "expiration_timestamp"=>1531308130
      }
    end

    before do
      stub_request(
        :post,
        "https://trade.bloom.solutions/api/v1/quotes"
      ).to_return(body: mock_response.to_json)
    end

    it "returns a quote" do
      response = described_class.new.get_quote(
        "some-token", 
        params
      )

      body = JSON.parse(response.body)

      expect(response).to be_success
      expect(body["base_currency"]).to eq "BTC"
      expect(body["counter_currency"]).to eq "PHP"
      expect(body["quote_type"]).to eq "buy"
      expect(body["amount"]).to eq "100.0"
      expect(body["price"]).to eq "100000"
      expect(body["total"]).to eq "10000000"
      expect(body["bx8_fee"]).to eq "100"
      expect(body["memo"]).to eq "some-random-string"
      expect(body["expiration_timestamp"]).to_not be_nil
    end

  end
end
