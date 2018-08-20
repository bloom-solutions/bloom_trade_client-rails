require "spec_helper"

RSpec.describe "Get Quote" do
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

  it "returns a quote", vcr: { record: :once } do
    response = client.get_quote(params)

    expect(response).to be_success
    expect(response.base_currency).to eq "BTC"
    expect(response.counter_currency).to eq "PHP"
    expect(response.quote_type).to eq "sell"
    expect(response.amount).to eq 1.5
    expect(response.price).to be_a BigDecimal
    expect(response.total).to be_a BigDecimal
    expect(response.bx8_fee).to be_a BigDecimal
    expect(response.memo).to be_a String
    expect(response.expiration_timestamp).to be_an Integer
  end
end
