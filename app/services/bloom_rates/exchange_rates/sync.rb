module BloomRates
  module ExchangeRates
    class Sync
      def self.call(payload)
        parsed_payload = JSON.parse(payload)

        parsed_payload.map do |data|
          exchange_rate = BloomRates::ExchangeRate.where(
            base_currency: data['base_currency'],
            counter_currency: data['counter_currency']
          ).first_or_initialize

          sync(exchange_rate, data)
        end
      end

      def self.sync(exchange_rate, data)
        exchange_rate.update_attributes(
          buy: data['buy'],
          sell: data['sell'],
          mid: data['mid']
        )
      end
    end
  end
end
