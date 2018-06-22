# BloomRates
Mountable Exchange Rates client for market data coming from Bloom Trade

## Usage

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'message_bus-client', git: 'https://github.com/bloom-solutions/message_bus-client', ref: 'bloom_changes'
gem 'bloom_rates-rails'
```

Add an initializer `config/initializers/bloom_rates.rb`

```ruby
# Creates a subscription to the bloom trade server. Whenever exchange rates
# are updated, your local database will get the latest exchange rates.

BloomRates.setup
```

And then execute:
```bash
$ bundle
```

In your `config/routes.rb`
```ruby
mount BloomRates::Engine => "/bloom_rates"
```

After mounting run migrations

```bash
# This creates the ExchangeRate table which will store exchange rate
# history for currencies.

rails bloom_rates:install:migrations
```

### Configuration

In your initializer you can configure the gem

```
# config/initializers/bloom_rates

BloomRates.configure do |c|
  c.publisher_url = "https://whatever.com"
  c.reserve_currency = "PHP"
end
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
