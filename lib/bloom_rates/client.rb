module BloomRates
  class Client
    include HTTParty

    def get_quote(token, quote = {})
      query_string = {
        quote: {
          base_currency: quote.fetch(:base_currency),
          counter_currency: quote.fetch(:counter_currency),
          quote_type: quote.fetch(:quote_type),
          amount: quote.fetch(:amount),
        }
      }

      uri = Addressable::URI.parse(BloomRates.configuration.bloom_trade_url)
      uri.path = "/api/v1/quotes"

      self.class.post(
        uri.to_s,
        body: query_string.to_json,
        headers: header_with_token(token)
      )
    end

    private

    def header_with_token(token)
      {
        "Authorization" => "Bearer #{token}",
        "Content-Type"  => "application/json"
      }
    end

  end
end
