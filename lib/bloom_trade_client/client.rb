module BloomTradeClient
  class Client

    include APIClientBase::Client.module(default_opts: :all_opts)
    attribute :host, String
    attribute :token, String

    api_action :get_quote
    api_action :update_quote
    api_action :get_order, args: [:memo]

    private

    def all_opts
      {
        host: host,
        token: token,
      }
    end

  end
end
