module BloomTradeClient
  class ConvertResult

    include Virtus.model

    attribute :rate, BigDecimal
    attribute :state, String
    attribute :expires_at, DateTime

  end
end
