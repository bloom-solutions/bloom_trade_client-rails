module BloomTradeClient
  class ExchangeRate < ApplicationRecord

    RESOLVER_DIRECTIONS = {
      direct: "direct",
      reversed: "reversed",
    }

    def expired?
      return true unless expires_at

      expires_at_in_utc = Time.at(expires_at).utc
      expires_at_in_utc < Time.now.utc
    end

    def self.resolve(base_currency:, counter_currency:, jwt:)
      jwt_hash = jwt ? Digest::SHA256.base64digest(jwt) : nil
      resolution = {}

      direct_rate = find_by(
        base_currency: base_currency,
        counter_currency: counter_currency,
        jwt_hash: jwt_hash,
      )

      if direct_rate
        resolution[:rate] = direct_rate
        resolution[:direction] = RESOLVER_DIRECTIONS[:direct]
      end

      reversed_rate = find_by(
        base_currency: counter_currency,
        counter_currency: base_currency,
        jwt_hash: jwt_hash,
      )

      if reversed_rate
        resolution[:rate] = reversed_rate
        resolution[:direction] = RESOLVER_DIRECTIONS[:reversed]
      end

      resolution
    end

  end
end
