module BloomTradeClient
  module ExchangeRates
    class Convert

      def self.call(
        base_currency:,
        counter_currency:,
        reserve_currency: BloomTradeClient.configuration.reserve_currency,
        type: "mid"
      )
        rate = direct_rate(type, base_currency, counter_currency)
        return rate if rate

        origin_rate = direct_rate(type, base_currency, reserve_currency)
        destination_rate = direct_rate(type, reserve_currency, counter_currency)
        reverse_rate = origin_rate.rate * destination_rate.rate if origin_rate && destination_rate
        return ConversionResult.new(rate: reverse_rate) if reverse_rate

        Rails.logger.error(
          "Unable to calculate rate #{base_currency}#{counter_currency}"
        )
        return ConversionResult.new(rate: 0.0)
      end

      private

      def self.direct_rate(type, base_currency, counter_currency)
        return nil unless %w(buy sell mid).include? type

        return ConversionResult.new(rate: 1.0) if base_currency == counter_currency

        exchange_rate = ExchangeRate.find_by(
          base_currency: base_currency,
          counter_currency: counter_currency,
        )

        if exchange_rate
          return ConversionResult.new(
            rate: exchange_rate.send(type.to_sym),
            expires_at: exchange_rate.expires_at
          )
        end

        reversed_rate = ExchangeRate.find_by(
          base_currency: counter_currency,
          counter_currency: base_currency,
        )

        if reversed_rate
          return ConversionResult.new(
            rate: 1.0 / reversed_rate.send(type.to_sym),
            expires_at: reversed_rate.expires_at
          )
        end
      end
    end
  end
end
