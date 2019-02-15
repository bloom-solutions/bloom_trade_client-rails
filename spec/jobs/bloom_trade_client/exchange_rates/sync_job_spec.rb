require "spec_helper"

module BloomTradeClient
  module ExchangeRates
    RSpec.describe SyncJob do

      let(:host) { CONFIG[:host] }
      let(:processor) { BloomTradeClient::ExchangeRates::Sync }
      let(:global_channel) { BloomTradeClient::RATES_CHANNEL }
      let(:org_channel) { BloomTradeClient::ORG_RATES_CHANNEL }

      before do
        BloomTradeClient.configure do |c|
          c.host = host
          c.jwt_callback = -> { [CONFIG[:bloom_trade_api_token]] }
        end
      end

      it "fetches rates globally and per JWT given" do
        expect(MessageBusClientWorker::SubscriptionWorker).to receive(:perform_async).
          with(host, {channels: {global_channel => {processor: processor.to_s, message_id: 0}}})

        callback = BloomTradeClient.configuration.jwt_callback

        callback.().each do |client|
          expect(MessageBusClientWorker::SubscriptionWorker).to receive(:perform_async).
            with(host, {
              headers: { "Authorization" => "Bearer #{client}" },
              channels: {
                org_channel => { processor: processor.to_s, message_id: 0 }
              }
            })
        end

        described_class.new.perform
      end
    end
  end
end
