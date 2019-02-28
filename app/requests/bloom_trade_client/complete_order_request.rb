module BloomTradeClient
  class CompleteOrderRequest < BaseAuthenticatedRequest

    attribute :memo, String

    def path
      "/api/v2/orders/:memo/complete"
    end

    def default_action
      :put
    end

  end
end
