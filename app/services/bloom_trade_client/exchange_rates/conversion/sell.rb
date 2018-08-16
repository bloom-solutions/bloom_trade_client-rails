module BloomTradeClient
  module ExchangeRates
    module Conversion
      class Sell
        def self.call(base_currency, counter_currency)
          return 1.0 if base_currency == counter_currency

          exchange_rate = ExchangeRate.
            find_by(base_currency: base_currency, counter_currency: counter_currency)

          return exchange_rate.sell if exchange_rate

          reversed_rate = ExchangeRate.
            find_by(base_currency: counter_currency, counter_currency: base_currency)

          return 1.0 / reversed_rate.buy if reversed_rate
        end
      end
    end
  end
end
