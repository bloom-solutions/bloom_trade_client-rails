module BloomTradeClient
  module ExchangeRates
    class Convert

      def self.call(
        base_currency:,
        counter_currency:,
        reserve_currency: BloomTradeClient.configuration.reserve_currency,
        type: "mid",
        jwt:
      )
        rate = calculate_rate(type, base_currency, counter_currency, jwt)
        return rate if rate

        origin_rate = calculate_rate(type, base_currency, reserve_currency, jwt)
        destination_rate = calculate_rate(type, reserve_currency, counter_currency, jwt)
        reverse_rate = origin_rate.rate * destination_rate.rate if origin_rate && destination_rate
        return ConversionResult.new(rate: reverse_rate) if reverse_rate

        Rails.logger.error(
          "Unable to calculate rate #{base_currency}#{counter_currency}"
        )
        return ConversionResult.new(rate: 0.0)
      end

      def self.calculate_rate(type, base_currency, counter_currency, jwt)
        return unless %w(buy sell mid).include? type
        return ConversionResult.new(rate: 1.0) if base_currency == counter_currency

        jwt_hash = jwt ? Digest::SHA256.base64digest(jwt) : nil
        opts = { 
          base_currency: base_currency, 
          counter_currency: counter_currency, 
          jwt_hash: jwt_hash 
        }

        direct_rate_for(type, opts) || reversed_rate_for(type, opts)
      end
      private_class_method :calculate_rate

      def self.direct_rate_for(type, opts)
        rate = ExchangeRate.find_by(opts)
        return unless rate

        ConversionResult.new(
          rate: rate.send(type.to_sym),
          expires_at: rate.expires_at
        )
      end
      private_class_method :direct_rate_for

      def self.reversed_rate_for(type, opts)
        rate = ExchangeRate.find_by(
          base_currency: opts[:counter_currency],
          counter_currency: opts[:base_currency],
          jwt_hash: opts[:jwt_hash]
        )
        return unless rate

        ConversionResult.new(
          rate: 1.0 / rate.send(type.to_sym),
          expires_at: rate.expires_at
        )
      end
      private_class_method :reversed_rate_for

    end
  end
end
