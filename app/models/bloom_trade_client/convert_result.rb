module BloomTradeClient
  class ConvertResult

    include Virtus.model

    STATES = {
      valid: "valid",
      expired: "expired",
      invalid: "invalid",
    }

    attribute :rate, BigDecimal
    attribute :state, String
    attribute :message, String
    attribute :request, ConvertRequest
    attribute :expires_at, DateTime

    def expired?
      return false unless expires_at

      expires_at < Time.now.utc
    end

    STATES.keys.each do |key|
      define_method("#{key.to_s}?".to_sym) do
        state == STATES[key.to_sym]
      end
    end

  end
end
