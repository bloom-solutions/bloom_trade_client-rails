# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic
Versioning](http://semver.org/spec/v2.0.0.html).

## [0.16.2] - 2018-11-23
### Added
- Install `virtus-matchers` gem
- Unit test for `BloomTradeClient::ConversionResult`

### Changed
- Convert `BloomTradeClient::ConversionResult` to a Virtus model

## [0.16.1] - 2018-11-09
### Fixed
- Fix not returning `BloomTradeClient::ConversionResult` on reverse rates

## [0.16.0] - 2018-11-08
### Changed
- `BloomTradeClient::ExchangeRates::Sync` now returns `expires_at` field
- `BloomTradeClient::ExchangeRates::Convert` now returns `BloomTradeClient::ConversionResult` object
- Upgrade `loofah` gem to 2.2.3

## [0.15.0] - 2018-09-15
### Changed
- Do not register the schedule; require devs to set it up themselves

## [0.14.1] - 2018-09-05
### Added
- Fix `stellar_address`, not `stellar_account` (in `GetQuoteResponse`)

## [0.14.0] - 2018-09-05
### Added
- `stellar_address` in `GetQuoteResponse`

## [0.13.0] - 2018-08-24
### Added
- Add `amount_type` in `GetQuoteRequest` and `GetQuoteResponse`

### Changed
- Pin versions of dependencies in gemspec

## [0.12.0] - 2018-08-22
### Added
- Add `BloomTradeClient::Client#update_quote`
- Refactor rate type calculations on `BloomTradeClient::ExchangeRates::Convert`

## [0.11.0] - 2018-08-16
### Changed
- Renamed gem into `bloom_trade_client-rails` from `bloom_rates-rails`

## [0.10.0] - 2018-08-08
### Changed
- remove calling of `BloomRates.setup`
- add migration to drop last ids table since this is no longer used

## [0.9.0] - 2018-08-08
### Changed
- Change `BloomRates::ExchangeRates::Sync.call` method
  - Make method accept 2 arguments
  - Parse incoming json payload inside the method
- Use `message_bus_client_worker` instead of `message_bus-client`

## [0.8.1] - 2018-08-01
### Fixed
- Fix error when sending quote request to bloom_trade

## [0.8.0] - 2018-08-01
### Changed
- Remove `bloom_trade_api_token` from gem config
- Move to use api_client_base
  - change `bloom_trade_url` to `host`
  - when BloomRates::Client is initialized, the api token is passed in
  - change the method signature of `get_quote` response - see `spec/lib/bloom_rates/client_spec.rb`

## [0.6.0] - 2018-07-31
- Create MessageBusLastId.create_or_update
- Only store 1 record of `MessageBusLastId`

## [0.5.3] - 2018-07-12
- Change client test to use `webmock`
- Remove `vcr` dependency

## [0.5.2] - 2018-07-12
- Load dependencies when engine is loaded

## [0.5.1] - 2018-07-09
- Fix `httparty` required on test and not on app

## [0.5.0] - 2018-07-09
- Move factories to lib/factories to be used by gem users

## [0.4.0] - 2018-07-04
- Return raw response from bloom-trade endpoint
- Use vcr and webmock for testing BloomRates::Client

## [0.3.0] - 2018-07-04
- Change `publisher_url` to be `bloom_trade_url`
- Add `BloomRates::Client` for bloom_trade api consumption
- Add `BloomRates.convert` to convert between currencies

## [0.2.0] - 2018-06-25
### Changed
- Store and use `last_id` of `message_bus` to easily track updated rates

## [0.1.0] - 2018-06-25
- Initial deploy
