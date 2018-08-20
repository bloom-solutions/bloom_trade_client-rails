module BloomTradeClient
  class UpdateQuoteRequest < BaseAuthenticatedRequest
    attribute :memo, String
    attribute :destination_memo, String
    attribute :destination_address, String

    def path
      "/api/v1/quotes/#{memo}"
    end

    def default_action
      :put
    end

    def body
      {
        quote: {
          destination_memo: destination_memo,
          destination_address: destination_address,
        }
      }.to_json
    end
  end
end
