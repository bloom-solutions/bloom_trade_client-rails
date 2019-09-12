module BloomTradeClient
  class ConvertResult

    include Virtus.model

    STATES = {
      valid: "valid",
      invalid: "invalid",
    }

    attribute :rate, BigDecimal
    attribute :state, String, default: :default_state
    attribute :message, String
    attribute :request, ConvertRequest
    attribute :expires_at, DateTime

    def expired?
      return false unless expires_at

      expires_at < Time.now.utc
    end

    def success?
      invalid? ? false : true
    end

    def rate_currency
      request.counter_currency
    end

    STATES.keys.each do |key|
      define_method("#{key.to_s}?".to_sym) do
        state == STATES[key.to_sym]
      end
    end

    private

    def default_state
      "valid"
    end

  end
end
