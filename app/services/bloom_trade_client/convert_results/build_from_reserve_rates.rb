module BloomTradeClient
  module ConvertResults
    class BuildFromReserveRates

      def self.call(request)
        origin_resolution = origin_resolution_from(request)
        dest_resolution = dest_resolution_from(request)

        return if origin_resolution.empty? && dest_resolution.empty?

        origin_rate = rate_from(origin_resolution, request.request_type)
        dest_rate = rate_from(dest_resolution, request.request_type)
        expires_at = expires_at_from(
          origin_resolution[:rate],
          dest_resolution[:rate],
        )

        ConvertResult.new(
          rate: origin_rate * dest_rate,
          expires_at: expires_at,
          request: request,
        )
      end

      def self.origin_resolution_from(request)
        ExchangeRate.resolve(
          base_currency: request.base_currency,
          counter_currency: request.reserve_currency,
          jwt: request.jwt,
        )
      end
      private_class_method :origin_resolution_from

      def self.dest_resolution_from(request)
        ExchangeRate.resolve(
          base_currency: request.reserve_currency,
          counter_currency: request.counter_currency,
          jwt: request.jwt,
        )
      end
      private_class_method :dest_resolution_from

      def self.rate_from(resolution, request_type)
        rate = resolution[:rate]

        if resolution[:orientation] == "direct"
          rate.send(request_type.to_sym)
        else
          1.0 / rate.send(request_type.to_sym)
        end
      end
      private_class_method :rate_from

      def self.expires_at_from(orig_rate, dest_rate)
        if orig_rate.expires_at > dest_rate.expires_at
          dest_rate.expires_at
        else
          orig_rate.expires_at
        end
      end
      private_class_method :expires_at_from

    end
  end
end
