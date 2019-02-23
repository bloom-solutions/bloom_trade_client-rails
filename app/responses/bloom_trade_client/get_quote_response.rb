module BloomTradeClient
  class GetQuoteResponse < BaseResponse

    PARAMS = %i[
      base_currency
      counter_currency
      quote_type
      amount_type
      amount
      quoted_amount
      price
      total
      bx8_fee
      stellar_address
      memo
      expiration_timestamp
    ]

    attribute(:base_currency, String, {
      lazy: true,
      default: :default_base_currency,
    })
    attribute(:counter_currency, String, {
      lazy: true,
      default: :default_counter_currency,
    })
    attribute :quote_type, String, lazy: true, default: :default_quote_type
    attribute :amount, BigDecimal, lazy: true, default: :default_amount
    attribute :amount_type, String, lazy: true, default: :default_amount_type
    attribute(:quoted_amount, BigDecimal, {
      lazy: true,
      default: :default_quoted_amount
    })
    attribute :price, BigDecimal, lazy: true, default: :default_price
    attribute :total, BigDecimal, lazy: true, default: :default_total
    attribute :bx8_fee, BigDecimal, lazy: true, default: :default_bx8_fee
    attribute(:stellar_address, String, {
      lazy: true,
      default: :default_stellar_address,
    })
    attribute :memo, String, lazy: true, default: :default_memo
    attribute(:expiration_timestamp, Integer, {
      lazy: true,
      default: :default_expiration_timestamp
    })

    private

    PARAMS.each do |method_name|
      define_method :"default_#{method_name}" do
        parsed_body[method_name]
      end
    end

  end
end
