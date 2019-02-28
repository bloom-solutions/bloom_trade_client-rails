require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!

  %i[
    bloom_trade_api_token
    bloomx_issuer_address
    bx8_issuer_address
    bloom_trade_address
    stellar_address
  ].each do |var|
    c.filter_sensitive_data("[#{var}]") { CONFIG[var] }
  end
end
