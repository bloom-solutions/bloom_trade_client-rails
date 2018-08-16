module BloomRates
  class GetQuoteRequest

    include APIClientBase::Request.module(action: :post)
    attribute :token, String
    attribute :base_currency, String
    attribute :counter_currency, String
    attribute :quote_type, String
    attribute :amount, BigDecimal

    def path
      "/api/v1/quotes"
    end

    def body
      {
        quote: {
          base_currency: base_currency,
          counter_currency: counter_currency,
          quote_type: quote_type,
          amount: amount,
        }
      }.to_json
    end

    def headers
      {
        "Authorization" => "Bearer #{token}",
        "Content-Type" => "application/json",
      }
    end

  end
end
