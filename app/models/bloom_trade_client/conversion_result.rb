module BloomTradeClient
  class ConversionResult

    include Virtus.model

    attribute :rate, Float
    attribute :expires_at, Integer, default: 0

  end
end
