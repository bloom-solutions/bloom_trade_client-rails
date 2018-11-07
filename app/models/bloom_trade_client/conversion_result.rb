module BloomTradeClient
  class ConversionResult
    attr_reader :rate, :expires_at

    def initialize(rate, expires_at="")
      @rate = rate
      @expires_at = expires_at
    end
  end
end