module BloomRates
  module Trades
    class Client
      include HTTParty

      base_uri "https://staging.trade.bloom.solutions"

      def get_quote(quote = {})
        query_string = {
          quote: {
            base_currency: quote.fetch(:base_currency),
            counter_currency: quote.fetch(:counter_currency),
            quote_type: quote.fetch(:quote_type),
            amount: quote.fetch(:amount),
          }
        }

        response = self.class.post(
          "/api/v1/quotes",
          body: query_string,
          headers: auth_header
        )

        JSON.parse(response.body)
      end

      private

      def auth_header
        { "Authorization" => "Bearer #{ENV["BLOOM_TRADE_API_TOKEN"]}" }
      end

    end
  end
end
