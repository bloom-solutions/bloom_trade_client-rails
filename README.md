# BloomTradeClient

![](https://github.com/bloom-solutions/bloom_trade_client-rails/workflows/RSpec/badge.svg)

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

3. Enable the BloomTradeClient engine by mounting in your routes. In your `config/routes.rb`:

```ruby
mount BloomTradeClient::Engine => "/bloom_trade_client"
```

4. Add an initializer `config/initializers/bloom_trade_client.rb`

```ruby
BloomTradeClient.configure do |c|
  c.host = "https://trade-staging.bloom.solutions"
  c.reserve_currency = "PHP" # What the conversion service will use

  # Returns a list of jwt, this will be used for creating and maintaining
  # a different set of local ExchangeRate records per JWT.
  c.jwt_callback = -> { ["my_token", "his_token", "her_token"] }
end
```

5. Add the following to your sidekiq-cron schedule

```yaml
exchange_rates:
  cron: "*/30 * * * * *"
  class: "BloomTradeClient::ExchangeRates::SyncJob"
```

If you're new to sidekiq-cron, see the [docs](https://github.com/ondrejbartas/sidekiq-cron).

## API

#### Requesting a Quote from Bloom Trade

```ruby
client = BloomTradeClient::Client.new(token: "your-jwt-here")
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

if there are any errors, you can inspect using:

```
response.success?
response.errors
```

#### Updating a Quote from Bloom Trade

```ruby
response = client.update_quote(
  memo: "#{from_client.get_quote_quote}",
  destination_memo: "#{some_stellar_memo_bloom_trade_will_send_to}",
  destination_address: "#{some_stellar_address_bloom_trade_will_send_to}",
)
```

This so that Bloom Trade can issue the corresponding base/counter currency (based on quote type)
to fulfill the quote.

## Exchange Rates

#### Syncing exchange rates (manually)

Sometimes you would want to run the sync job manually for testing purposes, here's how to do it:

1. Open the rails console
2. `BloomTradeClient::ExchangeRates::SyncJob.new.perform`

#### Getting conversion and direct rates from a currency pair

Checking the value of a currency to another e.g. 1 BTC for USD. You can choose from either `buy, sell, mid`. Mid is the average value.

The result object is a `ConvertResult` object:

```ruby
# If you pass a type other than buy, mid or sell. This will raise an ArgumentError
result = BloomTradeClient.convert(
  base_currency: "BTC",
  counter_currency: "USD",
  type: "buy",
  jwt: "my-jwt"
)

# BloomTradeClient.convert will try to compute a rate from the local ExchangeRate records under that jwt.
# If you don't pass a jwt, it will use default ExchangeRate records.
result # ConvertResult

# This will return a ConvertRequest object, which essentially contains the params you passed in BloomTradeClient.convert
result.request # ConvertRequest

# valid conversion
result.success? # true
result.rate # BigDecimal
result.state # "valid"
result.valid? # true

# expired rates
result.success? # true, even if expired, .success returns that the rate is there, but it's just expired
result.expired? # true
result.state # "valid"

# can't find a currency
result.success? # false
result.message? # FOOBAR mid rate not available
result.invalid? # true
result.state # "invalid"

# Get the rate
result.rate # BigDecimal
result.rate_currency # what currency the rate amount is in
```

See `spec/acceptance` to see more examples of calls that can be made with `BloomTradeClient`.

## Development

- Copy the config and customize it (especially if you're re-recording cassettes): `cp spec/config.yml{.sample,}`
- `rails db:test:prepare`

## Releasing

The gem is hosted in gemfury under the Bloom Solutions account. The gem itself is public, to make a version and release it to the public you add the `fury` git origin:

```
git remote add fury https://git.fury.io/bloomsolutions/bloom_trade_client-rails.git
git push fury master
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
