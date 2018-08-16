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

        return origin_rate * destination_rate if origin_rate && destination_rate

        Rails.logger.error(
          "Unable to calculate rate #{base_currency}#{counter_currency}"
        )
        return 0.0
      end

      private

      def self.direct_rate(type, base_currency, counter_currency)
        return nil unless %w(buy sell mid).include? type

        [
          "BloomTradeClient",
          "ExchangeRates",
          "Conversion",
          type.capitalize
        ].join("::").constantize.(
          base_currency,
          counter_currency,
        )
      end
    end
  end
end
