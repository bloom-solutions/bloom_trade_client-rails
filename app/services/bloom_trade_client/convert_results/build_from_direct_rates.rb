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

        state = if rate.expired?
                  ConvertResult::STATES[:expired]
                else
                  ConvertResult::STATES[:valid]
                end

        calculated_rate = if resolution[:direction] == "direct"
                            rate.send(request_type.to_sym)
                          else
                            1.0 / rate.send(request_type.to_sym)
                          end

        ConvertResult.new(
          state: state,
          rate: calculated_rate,
          expires_at: rate.expires_at,
        )
      end

    end
  end
end
