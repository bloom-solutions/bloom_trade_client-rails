module BloomTradeClient
  module ConvertResults
    class BuildFromDirectRates

      def self.call(request)
        request_type = request.request_type

        resolution = ExchangeRate.resolve(
          base_currency: request.base_currency,
          counter_currency: request.counter_currency,
          jwt: request.jwt,
        )

        return unless resolution[:rate]

        rate = resolution[:rate]

        calculated_rate = if resolution[:orientation] == "direct"
                            rate.send(request_type.to_sym)
                          else
                            1.0 / rate.send(request_type.to_sym)
                          end

        time = Time.at(rate.expires_at).utc

        ConvertResult.new(
          rate: calculated_rate,
          expires_at: DateTime.parse(time.to_s),
          request: request,
        )
      end

    end
  end
end
