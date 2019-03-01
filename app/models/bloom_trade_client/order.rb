module BloomTradeClient
  class Order

    include Virtus.model

    attribute :incoming_amount, BigDecimal
    attribute :outgoing_amount, BigDecimal
    attribute :outgoing_currency_slug, String
    attribute :incoming_currency_slug, String
    attribute :price, BigDecimal
    attribute :received_amount, BigDecimal
    attribute :payable_amount, BigDecimal
    attribute :status, String

  end
end
