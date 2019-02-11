module BloomTradeClient
  module ExchangeRates
    class Convert

      def self.call(
        base_currency:,
        counter_currency:,
        reserve_currency: BloomTradeClient.configuration.reserve_currency,
        type: "mid",
        user_id:
      )
        rate = direct_rate(type, base_currency, counter_currency, user_id)
        return rate if rate

        origin_rate = direct_rate(type, base_currency, reserve_currency, user_id)
        destination_rate = direct_rate(type, reserve_currency, counter_currency, user_id)
        reverse_rate = origin_rate.rate * destination_rate.rate if origin_rate && destination_rate
        return ConversionResult.new(rate: reverse_rate) if reverse_rate

        Rails.logger.error(
          "Unable to calculate rate #{base_currency}#{counter_currency}"
        )
        return ConversionResult.new(rate: 0.0)
      end

      private

      def self.direct_rate(type, base_currency, counter_currency, user_id)
        return nil unless %w(buy sell mid).include? type
        return ConversionResult.new(rate: 1.0) if base_currency == counter_currency

        jwt_hash = user_id ? Base64.encode64(user_id) : nil

        exchange_rate = ExchangeRate.find_by(
          base_currency: base_currency,
          counter_currency: counter_currency,
          jwt_hash: jwt_hash
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
          jwt_hash: jwt_hash
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
