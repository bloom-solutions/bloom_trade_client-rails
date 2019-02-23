require "spec_helper"

RSpec.describe "Update Quote" do
  let(:client) do
    client = BloomTradeClient::Client.new(
      host: "https://staging.trade.bloom.solutions",
      token: CONFIG[:bloom_trade_api_token],
    )
  end

  let(:params) do
    {
      base_currency: "BTC",
      counter_currency: "PHP",
      quote_type: "sell",
      amount: 1.5,
    }
  end

  context "when quote has been updated" do
    it "returns errors and 400", vcr: { record: :once } do
      get_quote_response = client.get_quote(params)

      expect(get_quote_response).to be_success
      expect(get_quote_response.base_currency).to eq "BTC"
      expect(get_quote_response.counter_currency).to eq "PHP"
      expect(get_quote_response.quote_type).to eq "sell"

      initial_update_quote_response = client.update_quote(
        memo: get_quote_response.memo,
        destination_address: "G-1234",
        destination_memo: "V1234",
      )

      response = client.update_quote(
        memo: get_quote_response.memo,
        destination_address: "G-1234",
        destination_memo: "V1234",
      )

      expect(response).not_to be_success
      json = response.parsed_body

      expect(json["errors"]["destination_memo"])
        .to include "is already assigned"
      expect(json["errors"]["destination_address"])
        .to include "is already assigned"
    end
  end

  context "when quote hasn't been updated" do
    it "updates a quote and returns 200", vcr: { record: :once } do
      get_quote_response = client.get_quote(params)

      expect(get_quote_response).to be_success
      expect(get_quote_response.base_currency).to eq "BTC"
      expect(get_quote_response.counter_currency).to eq "PHP"
      expect(get_quote_response.quote_type).to eq "sell"

      response = client.update_quote(
        memo: get_quote_response.memo,
        destination_address: "G-1234",
        destination_memo: "V1234",
      )

      expect(response).to be_success
    end
  end
end
