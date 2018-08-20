module BloomTradeClient
  class BaseAuthenticatedRequest

    include APIClientBase::Request.module
    attribute :token, String

    def headers
      {
        "Authorization" => "Bearer #{token}",
        "Content-Type" => "application/json",
      }
    end
  end
end
