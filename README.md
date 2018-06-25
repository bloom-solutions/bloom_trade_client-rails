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

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
