# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic
Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
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
