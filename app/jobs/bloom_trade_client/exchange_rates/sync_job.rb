module BloomTradeClient
  module ExchangeRates
    class SyncJob

      include Sidekiq::Worker

      def perform
        _run_global_subscriptions
        _run_per_jwt_subscriptions
      end

      private

      def subscriptions_of(scope:)
        host = BloomTradeClient.configuration.host
        processor = BloomTradeClient::ExchangeRates::Sync

        case scope.to_s
        when "global"
          {
            host => {
              channels: {
                BloomTradeClient::RATES_CHANNEL => {
                  processor: processor.to_s,
                  message_id: 0,
                }
              }
            }
          }
        when "org"
          {
            host => {
              channels: {
                BloomTradeClient::ORG_RATES_CHANNEL => {
                  processor: processor.to_s,
                  message_id: 0,
                }
              }
            }
          }
        end
      end

      def _run_global_subscriptions
        subscriptions_of(scope: :global).each do |host, subscription|
          enqueue_for host, subscription
        end
      end

      def _run_per_jwt_subscriptions
        callback = BloomTradeClient.configuration.jwt_callback
        return unless callback
        list_of_jwts = callback.()

        list_of_jwts.each do |jwt|
          auth_header = { "Authorization" => "Bearer #{jwt}" }

          subscriptions_of(scope: :org).each do |host, subscription|
            enqueue_for host, subscription.merge(headers: auth_header)
          end
        end
      end

      def enqueue_for(host, subscription)
        if MessageBusClientWorkerVersionEvaluator.version_2_1_1_and_greater?
          subscription = subscription.to_json
        end

        MessageBusClientWorker::SubscriptionWorker.
          perform_async(host, subscription)
      end

    end
  end
end
