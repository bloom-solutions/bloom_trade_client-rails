# BloomTradeClient

[![Build Status](https://travis-ci.org/bloom-solutions/bloom_trade_client-rails.svg?branch=master)](https://travis-ci.org/bloom-solutions/bloom_trade_client-rails)

Mountable Exchange Rates client for market data coming from Bloom Trade

## Usage

### Installation

This uses [Sidekiq](https://github.com/mperham/sidekiq) and [sidekiq-cron](https://github.com/ondrejbartas/sidekiq-cron) to fetch messages from the rates server.

1. Add this line to your application's Gemfile:
```ruby
gem 'bloom_trade_client-rails'
```

2. Copy needed migrations
```bash
rails bloom_trade_client:install:migrations
```

3. Enable the BloomTradeClient engine by mounting in your routes
In your `config/routes.rb`
```ruby
mount BloomTradeClient::Engine => "/bloom_trade_client"
```

4. Add an initializer `config/initializers/bloom_trade_client.rb`

```ruby
BloomTradeClient.configure do |c|
  c.host = "https://staging.trade.bloom.solutions"
  c.reserve_currency = "PHP" # What the conversion service will use
end
```

5. Add another initializer if you don't have one yet `config/initializers/message_bus_client_worker.rb`:

```ruby
MessageBusClientWorker.configure do |c|
  c.subscriptions = {
    "https://staging.trade.bloom.solutions" => {
      BloomTradeClient::EXCHANGE_RATES_CHANNEL => {
        processor: BloomTradeClient::ExchangeRates::Sync.to_s,
        message_id: 0,
      }
    }
  }
end
```

This gem used to set up MessageBusClientWorker for you, but if you were to use that elsewhere in your app, that introduced the possibility overwriting the config accidentally. Setting it up explicitly avoids that.

6. Add the following to your sidekiq-cron schedule (unless you're already doing this for something else in your app):

```yaml
message_bus_client_worker:
  cron: "*/30 * * * * *"
  class: "MessageBusClientWorker::EnqueuingWorker"
```

If you're new to sidekiq-cron, see the [docs](https://github.com/ondrejbartas/sidekiq-cron).

## API

Requesting a Quote from Bloom Trade

```ruby
client = BloomTradeClient::Client.new(token: "your-api-token-here")
response = client.get_quote(
  base_currency: "BTC",
  counter_currency: "PHP",
  quote_type: "buy",
  amount: 0.50, # in BTC (base currency)
)

response.price
response.bx8_fee
```

If you need to how much BTC (base currency) is X PHP, you can use:

```
response = client.get_quote(
  base_currency: "BTC",
  counter_currency: "PHP",
  quote_type: "buy",
  amount: 5_000, # in PHP (counter currency)
  amount_type: "counter", # This tells BloomTrade we're asking how much BTC we'll get for PHP5,000
)

response.quoted_amount # this is where you'll get the BTC amount
```

Updating a Quote from Bloom Trade

```ruby
response = client.update_quote(
  memo: "#{from_client.get_quote_quote}",
  destination_memo: "#{some_stellar_memo_bloom_trade_will_send_to}",
  destination_address: "#{some_stellar_address_bloom_trade_will_send_to}",
)
```

This so that Bloom Trade can issue the corresponding base/counter currency (based on quote type)
to fulfill the quote.

Checking the value of a currency to another e.g. 1 BTC for USD. You can choose
from either `["buy", "sell", "mid"]`. Mid is the average value.
```ruby
result = BloomTradeClient.convert(
  base_currency: "BTC", counter_currency: "USD", type: "buy"
)
```

See `spec/acceptance` to see more examples of calls that can be made with `BloomTradeClient`.

## Development

Copy the config and customize it (especially if you're re-recording cassettes): `cp spec/config.yml{.sample,}`

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
