module BloomTradeClient
  class GetOrderResponse < BaseResponse

    attribute(:order, BloomTradeClient::Order, {
      lazy: true,
      default: :default_order,
    })

    private

    def default_order
      BloomTradeClient::Order.new(parsed_body)
    end

  end
end
