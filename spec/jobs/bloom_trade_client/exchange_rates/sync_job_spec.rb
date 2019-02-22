require "spec_helper"

module BloomTradeClient
  module ExchangeRates
    RSpec.describe SyncJob do

      let(:host) { CONFIG[:host] }
      let(:processor) { BloomTradeClient::ExchangeRates::Sync }
      let(:global_channel) { BloomTradeClient::RATES_CHANNEL }
      let(:org_channel) { BloomTradeClient::ORG_RATES_CHANNEL }
      let(:token) { CONFIG[:bloom_trade_api_token] }

      before do
        BloomTradeClient.configure do |c|
          c.host = host
          c.jwt_callback = -> { [token] }
        end
      end

      it("fetches rates globally and per JWT given", {
        vcr: {record: :once, match_requests_on: [:method]},
      }) do
        described_class.new.perform

        expect(BloomTradeClient::ExchangeRate.count).to be > 0
        org_rates = BloomTradeClient::ExchangeRate.where(
          jwt_hash: Digest::SHA256.base64digest(token)
        )

        expect(org_rates.count).to be > 0
      end
    end
  end
end
