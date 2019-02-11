module BloomTradeClient
  module ExchangeRates
    class SyncJob

      include Sidekiq::Worker

      def perform
        _run_global_subscriptions
        _run_per_jwt_subscriptions
      end

      private

      def subscriptions
        host      = BloomTradeClient.configuration.host
        channel   = BloomTradeClient::EXCHANGE_RATES_CHANNEL
        processor = BloomTradeClient::ExchangeRates::Sync

        {
          host => {
            channels: {
              channel => {
                processor: processor.to_s,
                message_id: 0,
              }
            }
          }
        }
      end

      def _run_global_subscriptions
        subscriptions.each do |host, subs|
          MessageBusClientWorker::SubscriptionWorker.perform_async(host, subs)
        end
      end

      def _run_per_jwt_subscriptions
        callback = BloomTradeClient.configuration.jwt_callback
        return unless callback
        list_of_jwts = callback.()

        list_of_jwts.each do |jwt|
          auth_header = { "Authorization" => "Bearer #{jwt}" }

          subscriptions.each do |host, subs|
            subs.merge!(headers: auth_header)
            MessageBusClientWorker::SubscriptionWorker.perform_async(host, subs)
          end
        end
      end

    end
  end
end
