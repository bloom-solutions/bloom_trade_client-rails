module BloomTradeClient
  module ExchangeRates
    class Sync

      PATTERN = /^Bearer\s\S+/

      def self.call(data, _, headers)
        exchange_rate = BloomTradeClient::ExchangeRate.where(
          base_currency: data["base_currency"],
          counter_currency: data["counter_currency"],
          jwt_hash: get_jwt_from(headers)
        ).first_or_initialize

        exchange_rate.update_attributes!(
          buy: data["buy"],
          sell: data["sell"],
          mid: data["mid"],
          expires_at: data["expires_at"],
        )
      end

      def self.get_jwt_from(headers)
        return unless headers

        auth = headers["Authorization"]
        return unless auth

        if data = auth.match(PATTERN)
          token = data.to_s.split(" ").last
          Digest::SHA256.base64digest(token)
        end
      end
      private_class_method :get_jwt_from

    end
  end
end
