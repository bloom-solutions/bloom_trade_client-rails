module BloomRates
  class GetQuoteRequest

    include APIClientBase::Request.module(action: :post)
    attribute :token, String

    def path
      "/api/v1/quotes"
    end

    def headers
      {
        "Authorization" => "Bearer #{token}",
        "Content-Type" => "application/json",
      }
    end

  end
end
