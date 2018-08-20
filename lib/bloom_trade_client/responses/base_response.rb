module BloomTradeClient
  class BaseResponse
    include APIClientBase::Response.module

    attribute :body, String, lazy: true, default: :default_body

    private

    def default_body
      JSON.parse(raw_response.body).with_indifferent_access
    end

  end
end


