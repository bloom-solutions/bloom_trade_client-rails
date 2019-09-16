module BloomTradeClient
  class ConvertRequest

    include Virtus.model

    VALID_REQUEST_TYPES = %w[buy mid sell]

    attribute :base_currency, String
    attribute :counter_currency, String
    attribute :reserve_currency, String, default: :default_reserve_currency
    attribute :request_type, String, default: :default_request_type
    attribute :jwt, String

    def currency_pair
      [base_currency, counter_currency].join
    end

    def validate
      return true if VALID_REQUEST_TYPES.include?(request_type)

      error = [
        "invalid request_type '#{request_type}'.",
        "Valid request_types #{VALID_REQUEST_TYPES.join(", ")}",
      ].join(" ")
      raise ArgumentError, error
    end

    private

    def default_reserve_currency
      BloomTradeClient.configuration.reserve_currency
    end

    def default_request_type
      "mid"
    end

  end
end
