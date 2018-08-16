module BloomTradeClient
  module ExchangeRates
    class Sync

      def self.call(data, _)
        exchange_rate = BloomTradeClient::ExchangeRate.where(
          base_currency: data['base_currency'],
          counter_currency: data['counter_currency']
        ).first_or_initialize

        exchange_rate.update_attributes!(
          buy: data['buy'],
          sell: data['sell'],
          mid: data['mid'],
        )
      end

    end
  end
end
