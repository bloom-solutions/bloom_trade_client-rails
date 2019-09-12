module BloomTradeClient
  module ConvertResults
    class BuildInvalid

      def self.call(request)
        ConvertResult.new(
          state: ConvertResult::STATES[:invalid],
          message: message_from(request),
          request: request,
        )
      end

      def self.message_from(request)
        "#{request.currency_pair} #{request.request_type} rate not available"
      end

    end
  end
end
