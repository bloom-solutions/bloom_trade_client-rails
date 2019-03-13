module BloomTradeClient
  class ExpiredRateError < StandardError
    def self.message_from(base_currency, counter_currency, expires_at)
      "The rate has expired for currency pair " \
      "#{base_currency}#{counter_currency}. " \
      "Expiry time is #{Time.at(expires_at)}."
    end
  end
end
