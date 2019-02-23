module BloomTradeClient
  class BaseResponse
    include APIClientBase::Response.module

    attribute :body, String, lazy: true, default: :default_body
    attribute :parsed_body, Object, lazy: true, default: :default_parsed_body
    attribute :errors, Hash, lazy: true, default: :default_errors

    private

    def default_body
      raw_response.body
    end

    def default_parsed_body
      JSON.parse(body).with_indifferent_access
    end

    def default_errors
      errors = parsed_body[:errors]
      errors.with_indifferent_access.deep_symbolize_keys if errors.present?
    end
  end
end
