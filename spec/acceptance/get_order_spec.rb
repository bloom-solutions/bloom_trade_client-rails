require "spec_helper"

RSpec.describe "Get order" do
  let(:client) do
    BloomTradeClient::Client.new(
      host: "https://trade-staging.bloom.solutions",
      token: CONFIG[:bloom_trade_api_token],
    )
  end

  it "returns order info", vcr: { record: :once } do
    # Order with memo must exist on the server
    response = client.get_order("LZZW")

    expect(response).to be_success

    order = response.order

    expect(order.incoming_amount.to_f).to eq 0.001
    expect(order.outgoing_amount.to_f).to eq 182.45
    expect(order.outgoing_currency_slug).to eq "PHP"
    expect(order.incoming_currency_slug).to eq "BTC"
    expect(order.price.to_f).to eq 182448.35139997214425
    expect(order.received_amount.to_f).to eq 0.001
    expect(order.status).to eq "completed"
  end

end
