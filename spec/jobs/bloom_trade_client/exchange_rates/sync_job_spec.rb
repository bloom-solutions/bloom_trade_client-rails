require "spec_helper"

module BloomTradeClient
  module ExchangeRates
    RSpec.describe SyncJob do

      let(:processor) { BloomTradeClient::ExchangeRates::Sync }
      let(:channel) { BloomTradeClient::EXCHANGE_RATES_CHANNEL }

      before do
        BloomTradeClient.configure do |c|
          c.host = "https://somedomain.com"
          c.jwt_callback = -> {
            ["me", "myself", "i"]
          }
        end
      end

      it "fetches rates globally and per JWT given" do
        expect(MessageBusClientWorker::SubscriptionWorker).to receive(:perform_async).
          with("https://somedomain.com", {channels: {channel => {processor: processor.to_s, message_id: 0}}})

        ["me", "myself", "i"].each do |client|
          expect(MessageBusClientWorker::SubscriptionWorker).to receive(:perform_async).
            with("https://somedomain.com", {
              headers: { "Authorization" => "Bearer #{client}" },
              channels: {
                channel => { processor: processor.to_s, message_id: 0 }
              }
            })
        end

        described_class.new.perform
      end
    end
  end
end
