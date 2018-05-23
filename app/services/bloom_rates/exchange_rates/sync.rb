module BloomRates
  module ExchangeRates
    class Sync
      def self.call(payload)
        parsed_payload = JSON.parse(payload)

        parsed_payload.map do |payload|
          exchange = ExchangeRate.where(
            base_currency: payload['base_currency'],
            counter_currency: payload['counter_currency']
          ).first_or_initialize

          exchange.update_attributes(
            buy: payload['buy'],
            sell: payload['sell'],
            mid: payload['mid']
          )
        end
      end
    end
  end
end
