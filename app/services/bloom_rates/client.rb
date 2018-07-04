module BloomRates
  class Client
    include HTTParty

    base_uri BloomRates.configuration.bloom_trade_url

    def get_quote(quote = {})
      query_string = {
        quote: {
          base_currency: quote.fetch(:base_currency),
          counter_currency: quote.fetch(:counter_currency),
          quote_type: quote.fetch(:quote_type),
          amount: quote.fetch(:amount),
        }
      }

      self.class.post(
        "/api/v1/quotes",
        body: query_string.to_json,
        headers: auth_header
      )
    end

    private

    def auth_header
      token = BloomRates.configuration.bloom_trade_api_token
      { 
        "Authorization" => "Bearer #{token}",
        "Content-Type"  => "application/json"
      }
    end

  end
end
