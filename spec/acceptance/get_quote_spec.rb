require "spec_helper"

RSpec.describe "Get Quote", vcr: { record: :once } do
  let(:params) do
    {
      base_currency: "BTC",
      counter_currency: "PHP",
      quote_type: "sell",
      amount: 1.5,
    }
  end
  let(:client) do
    BloomTradeClient::Client.new(
      host: "https://staging.trade.bloom.solutions",
      token: CONFIG[:bloom_trade_api_token],
    )
  end

  it "returns a quote" do
    response = client.get_quote(params)

    expect(response).to be_success
    expect(response.base_currency).to eq "BTC"
    expect(response.counter_currency).to eq "PHP"
    expect(response.quote_type).to eq "sell"
    expect(response.amount).to eq 1.5
    expect(response.amount_type).to eq "base"
    expect(response.quoted_amount).to eq 1.5
    expect(response.price).to be_a BigDecimal
    expect(response.total).to be_a BigDecimal
    expect(response.bx8_fee).to be_a BigDecimal
    expect(response.memo).to be_a String
    expect(response.expiration_timestamp).to be_an Integer
  end

  context "amount_type is counter" do
    it "returns a quoted_amount based on counter currency" do
      response = client.get_quote(
        params.merge(amount: 5_000, amount_type: "counter")
      )

      expect(response).to be_success
      expect(response.base_currency).to eq "BTC"
      expect(response.counter_currency).to eq "PHP"
      expect(response.quote_type).to eq "sell"
      expect(response.amount).to eq 5_000
      expect(response.amount_type).to eq "counter"
      expect(response.quoted_amount)
        .to eq (response.amount / response.price).round(7)
      expect(response.price).to be_a BigDecimal
      expect(response.total).to be_a BigDecimal
      expect(response.bx8_fee).to be_a BigDecimal
      expect(response.memo).to be_a String
      expect(response.expiration_timestamp).to be_an Integer
    end
  end
end
