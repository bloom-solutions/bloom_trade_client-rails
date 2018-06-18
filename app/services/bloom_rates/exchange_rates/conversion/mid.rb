module BloomRates
  module ExchangeRates
    module Conversion
      class Mid
        def self.call(base_currency, counter_currency)
          return 1.0 if base_currency == counter_currency

          exchange_rate = ExchangeRate.
            find_by(base_currency: base_currency, counter_currency: counter_currency)

          return exchange_rate.mid if exchange_rate

          reversed_rate = ExchangeRate.
            find_by(base_currency: counter_currency, counter_currency: base_currency)

          return 1.0 / reversed_rate.mid if reversed_rate
        end
      end
    end
  end
end
