module BloomTradeClient
  module ConvertResults
    class BuildFromDirectCurrencies

      def self.call(request)
        return if request.base_currency != request.counter_currency

        ConvertResult.new(
          request: request,
          state: "valid",
          rate: 1.0,
          expires_at: nil,
          message: "currencies are equal",
        )
      end

    end
  end
end
