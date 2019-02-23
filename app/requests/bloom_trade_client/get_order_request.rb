module BloomTradeClient
  class GetOrderRequest < BaseAuthenticatedRequest

    attribute :memo, String

    def path
      "/api/v2/orders/:memo"
    end

  end
end
