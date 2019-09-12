module BloomTradeClient
  class ConvertRequest

    include Virtus.model

    attribute :base_currency, String
    attribute :counter_currency, String
    attribute :reserve_currency, String, default: :default_reserve_currency
    attribute :request_type, String, default: :default_request_type
    attribute :jwt, String

    def currency_pair
      [base_currency, counter_currency].join
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
