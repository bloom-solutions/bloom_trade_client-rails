# BloomRates
Mountable Exchange Rates client for market data coming from Bloom Trade

## Usage

### Installation

1. Add this line to your application's Gemfile:
```ruby
gem 'message_bus-client', git: 'https://github.com/bloom-solutions/message_bus-client', ref: 'bloom_changes'
gem 'bloom_rates-rails'
```

2. Copy needed migrations
```bash
rails bloom_rates:install:migrations
```

3. Enable the BloomRates engine by mounting in your routes
In your `config/routes.rb`
```ruby
mount BloomRates::Engine => "/bloom_rates"
```

4. Add an initializer `config/initializers/bloom_rates.rb`
```ruby
# Creates a subscription to the bloom trade server. Whenever exchange rates
# are updated, your local database will get the latest exchange rates.

BloomRates.setup
```

5. Update gems
```bash
$ bundle
```

## API

Requesting a Quote from Bloom Trade
```ruby
params = { base_currency: "BTC", counter_currency: "PHP", quote_type: "buy", amount: 0.50 }
result = BloomRates::Client.new.get_quote(params)
```

Checking the value of a currency to another e.g. 1 BTC for USD. You can choose
from either `["buy", "sell", "mid"]`. Mid is the average value.
```ruby
result = BloomRates.convert(
  base_currency: "BTC", counter_currency: "USD", type: "buy"
)
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
