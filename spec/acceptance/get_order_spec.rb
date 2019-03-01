require "spec_helper"

RSpec.describe "Get order" do
  let(:client) do
    BloomTradeClient::Client.new(
      host: "https://trade-staging.bloom.solutions",
      token: CONFIG[:bloom_trade_api_token],
    )
  end
  let(:horizon_client) { Stellar::Client.new(horizon: CONFIG[:horizon_url]) }

  it "returns order info", vcr: { record: :once } do
    get_quote_response = client.get_quote(
      base_currency: "BTC",
      counter_currency: "PHP",
      quote_type: "sell",
      amount: 1.5,
    )

    expect(get_quote_response).to be_success

    # Update the quote to our address so that it can complete the order later
    # and not error
    update_quote_response = client.update_quote(
      memo: get_quote_response.memo,
      destination_memo: "ABC",
      destination_address: CONFIG[:stellar_address],
    )

    expect(update_quote_response).to be_success

    # Send BloomTrade assets so we can complete the order
    bloom_trade_account = Stellar::Account.
      from_address(get_quote_response.stellar_address)

    # Send BX8 to BloomTrade
    bx8_issuer_account = Stellar::Account.from_seed(CONFIG[:bx8_issuer_seed])
    bx8_asset = Stellar::Asset.alphanum4("BX8", bx8_issuer_account.keypair)

    horizon_client.send_payment({
      from: bx8_issuer_account,
      to: bloom_trade_account,
      amount: Stellar::Amount.new(get_quote_response.bx8_fee, bx8_asset),
      memo: get_quote_response.memo,
    })

    # Send partial BTCT
    bloomx_anchor_account = Stellar::Account.
      from_seed(CONFIG[:bloomx_issuer_seed])
    btct_asset = Stellar::Asset.
      alphanum4("BTCT", bloomx_anchor_account.keypair)

    horizon_client.send_payment(
      from: bloomx_anchor_account,
      to: bloom_trade_account,
      amount: Stellar::Amount.new(0.001, btct_asset),
      memo: get_quote_response.memo,
    )

    # Wait til BloomTrade says it got the BTCT
    Wait.new(attempts: 20).until do
      response = client.get_order(get_quote_response.memo)
      if response.success?
        order = response.order
        order.received_amount == 0.001
      else
        false
      end
    end

    response = client.get_order(get_quote_response.memo)

    expect(response).to be_success

    order = response.order
    expect(order.incoming_amount.to_f).to eq 1.5
    expect(order.outgoing_amount.to_f).to be > 0
    expect(order.outgoing_currency_slug).to eq "PHP"
    expect(order.incoming_currency_slug).to eq "BTC"
    expect(order.price.to_f).to be > 0
    expect(order.received_amount.to_f).to eq 0.001
    expect(order.payable_amount.to_f).to eq (0.001 * order.price).floor(2)
    expect(order.status).to eq "processing"
  end

end
