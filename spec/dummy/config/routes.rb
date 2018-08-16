Rails.application.routes.draw do
  mount BloomTradeClient::Engine => "/bloom_trade_client"
end
