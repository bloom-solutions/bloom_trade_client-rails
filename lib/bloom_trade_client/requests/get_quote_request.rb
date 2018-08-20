module BloomTradeClient
  class GetQuoteRequest < BaseAuthenticatedRequest

    attribute :base_currency, String
    attribute :counter_currency, String
    attribute :quote_type, String
    attribute :amount, BigDecimal

    def path
      "/api/v1/quotes"
    end

    def default_action
      :post
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

  end
end
