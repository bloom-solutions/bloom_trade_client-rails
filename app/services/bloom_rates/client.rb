module BloomRates
  class Client
    include HTTParty

    base_uri BloomRates.configuration.bloom_trade_url

    def get_quote(args = {})
      query_string = build_quote_from(args)

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
    
    def build_quote_from(args)
      query_string = Hash.new

      query_string[:quote] = {
        base_currency: args.fetch(:base_currency),
        counter_currency: args.fetch(:counter_currency),
        quote_type: args.fetch(:quote_type),
        amount: args.fetch(:amount),
      }

      query_string
    end

  end
end
