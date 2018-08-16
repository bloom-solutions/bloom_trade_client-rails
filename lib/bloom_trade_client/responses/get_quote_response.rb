module BloomRates
  class GetQuoteResponse

    PARAMS = %i[
      base_currency
      counter_currency
      quote_type
      amount
      price
      total
      bx8_fee
      memo
      expiration_timestamp
    ]

    include APIClientBase::Response.module
    attribute :body, Object, lazy: true, default: :default_body
    attribute :base_currency, String, lazy: true, default: :default_base_currency
    attribute(:counter_currency, String, {
      lazy: true,
      default: :default_counter_currency,
    })
    attribute :quote_type, String, lazy: true, default: :default_quote_type
    attribute :amount, BigDecimal, lazy: true, default: :default_amount
    attribute :price, BigDecimal, lazy: true, default: :default_price
    attribute :total, BigDecimal, lazy: true, default: :default_total
    attribute :bx8_fee, BigDecimal, lazy: true, default: :default_bx8_fee
    attribute :memo, String, lazy: true, default: :default_memo
    attribute(:expiration_timestamp, Integer, {
      lazy: true,
      default: :default_expiration_timestamp
    })

    private

    def path
      "/api/v1/quotes"
    end

    def headers
      {
        "Authorization" => "Bearer #{token}",
        "Content-Type" => "application/json",
      }
    end

    PARAMS.each do |method_name|
      define_method :"default_#{method_name}" do
        body[method_name]
      end
    end

    def default_body
      JSON.parse(raw_response.body).with_indifferent_access
    end

  end
end
