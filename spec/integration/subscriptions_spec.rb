require "spec_helper"

RSpec.describe "Global and per Org subscriptions" do

  let(:processor) { BloomTradeClient::ExchangeRates::Sync }

  it "creates global exchange rates", vcr: {match_requests_on: [:host, :method]} do
    expect(BloomTradeClient::ExchangeRate.count).to eq 0

    MessageBusClientWorker::SubscriptionWorker.new.perform(
      CONFIG[:host],
      {
        channels: {
          BloomTradeClient::RATES_CHANNEL => {
            processor: processor.to_s,
            message_id: 0,
          }
        }
      }
    )

    expect(BloomTradeClient::ExchangeRate.count).to be > 0
  end

  it "creates per Org exchange rates", vcr: {match_requests_on: [:host, :method]} do
    expect(BloomTradeClient::ExchangeRate.count).to eq 0

    token = CONFIG[:bloom_trade_api_token]

    MessageBusClientWorker::SubscriptionWorker.new.perform(
      CONFIG[:host],
      {
        headers: {
          "Authorization" => "Bearer #{token}"
        },
        channels: {
          BloomTradeClient::ORG_RATES_CHANNEL => {
            processor: processor.to_s,
            message_id: 0,
          }
        }
      }
    )

    org_rates = BloomTradeClient::ExchangeRate.where(
      jwt_hash: Digest::SHA256.base64digest(token)
    )

    expect(org_rates.count).to be > 0
  end

end
