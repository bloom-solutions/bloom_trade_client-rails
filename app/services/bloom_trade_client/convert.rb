module BloomTradeClient
  class Convert

    def self.call(
      base_currency:,
      counter_currency:,
      reserve_currency: BloomTradeClient.configuration.reserve_currency,
      type: "mid",
      jwt:
    )
      return ConvertResult.new(rate: 1.0) if base_currency == counter_currency

      rate = direct_rate(type, base_currency, counter_currency, jwt)
      return rate if rate

      origin_rate = direct_rate(type, base_currency, reserve_currency, jwt)
      destination_rate = direct_rate(
        type,
        reserve_currency,
        counter_currency,
        jwt,
      )

      reserve_rate = if origin_rate && destination_rate
                       origin_rate.rate * destination_rate.rate
                     end

      return ConvertResult.new(rate: reserve_rate) if reserve_rate

      Rails.logger.error(
        "Unable to calculate rate #{base_currency}#{counter_currency}",
      )
      ConvertResult.new(rate: 0.0)
    end

    def self.direct_rate(type, base_currency, counter_currency, jwt)
      resolution = ExchangeRate.resolve(
        base_currency: base_currency,
        counter_currency: counter_currency,
        jwt: jwt,
      )

      return unless resolution[:rate]

      rate = resolution[:rate]

      if rate.expired?
        raise(
          BloomTradeClient::ExpiredRateError,
          BloomTradeClient::ExpiredRateError.message_from(
            rate.base_currency,
            rate.counter_currency,
            rate.expires_at,
          )
        )
      end

      if resolution[:direction] == "direct"
        return ConvertResult.new(
          rate: rate.send(type.to_sym),
          expires_at: Time.at(rate.expires_at).utc,
        )
      else
        return ConvertResult.new(
          rate: 1.0 / rate.send(type.to_sym),
          expires_at: Time.at(rate.expires_at).utc,
        )
      end
    end
    private_class_method :direct_rate

  end
end
