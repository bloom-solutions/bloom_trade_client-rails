module BloomRates
  module ExchangeRates
    class Sync

      def self.call(data, _)
        data.each do |d|
          exchange_rate = BloomRates::ExchangeRate.where(
            base_currency: d['base_currency'],
            counter_currency: d['counter_currency']
          ).first_or_initialize

          exchange_rate.update_attributes!(
            buy: d['buy'],
            sell: d['sell'],
            mid: d['mid'],
          )
        end
      end

    end
  end
end
