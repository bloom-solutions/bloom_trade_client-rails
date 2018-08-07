# BloomRates

[![Build Status](https://travis-ci.org/bloom-solutions/bloom_rates-rails.svg?branch=master)](https://travis-ci.org/bloom-solutions/bloom_rates-rails)

Mountable Exchange Rates client for market data coming from Bloom Trade

## Usage

### Installation

This uses [Sidekiq](https://github.com/mperham/sidekiq) and [sidekiq-cron](https://github.com/ondrejbartas/sidekiq-cron) to fetch messages from the rates server.

1. Add this line to your application's Gemfile:
```ruby
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
BloomRates.configure do |c|
  c.host = "https://staging.trade.bloom.solutions"
end

BloomRates.setup
```

5. Add the following to your sidekiq-cron schedule (unless you're already doing this for something else in your app):

```yaml
message_bus_client_worker:
  cron: "*/30 * * * * *"
  class: "MessageBusClientWorker::EnqueuingWorker"
```

If you're new to sidekiq-cron, see the [docs](https://github.com/ondrejbartas/sidekiq-cron).

## API

Requesting a Quote from Bloom Trade
```ruby
client = BloomRates::Client.new(token: "your-api-token-here")
response = client.get_quote(
  base_currency: "BTC",
  counter_currency: "PHP",
  quote_type: "buy",
  amount: 0.50,
)

response.price
response.bx8_fee
```

Checking the value of a currency to another e.g. 1 BTC for USD. You can choose
from either `["buy", "sell", "mid"]`. Mid is the average value.
```ruby
result = BloomRates.convert(
  base_currency: "BTC", counter_currency: "USD", type: "buy"
)
```

See `spec/lib/bloom_rates/client_spec.rb` to see more examples of calls that can be made with BloomTrade.

## Development

Copy the config and customize it (especially if you're re-recording cassettes): `cp spec/config.yml{.sample,}`

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
