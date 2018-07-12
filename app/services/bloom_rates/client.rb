module BloomRates
  class Client
    include HTTParty

    base_uri BloomRates.configuration.bloom_trade_url

    def get_quote(base_currency:, counter_currency:, quote_type:, amount:)
      query_string = {
        quote: {
          base_currency: base_currency,
          counter_currency: counter_currency,
          quote_type: quote_type,
          amount: amount,
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
      token = 
        BloomRates.configuration.bloom_trade_api_token

      { 
        "Authorization" => "Bearer #{token}",
        "Content-Type"  => "application/json"
      }
    end
    
  end
end
