module BloomTradeClient
  class ExchangeRate < ApplicationRecord

    def expired?
      return true unless self.expires_at
      expires_at_in_utc = Time.at(self.expires_at).utc

      expires_at_in_utc < Time.now.utc
    end

  end
end
