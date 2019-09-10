module BloomTradeClient
  class ExchangeRate < ApplicationRecord

    RESOLVER_ORIENTATIONS = {
      direct: "direct",
      reversed: "reversed",
    }.freeze

    def expired?
      return false unless expires_at

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
        resolution[:orientation] = RESOLVER_ORIENTATIONS[:direct]
      end

      reversed_rate = find_by(
        base_currency: counter_currency,
        counter_currency: base_currency,
        jwt_hash: jwt_hash,
      )

      if reversed_rate
        resolution[:rate] = reversed_rate
        resolution[:orientation] = RESOLVER_ORIENTATIONS[:reversed]
      end

      resolution
    end

  end
end
