$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bloom_trade_client/version"

gem_description = "Mountable Rails Engine for building apps " \
  "on top of the BloomX anchor"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bloom_trade_client-rails"
  s.version     = BloomTradeClient::VERSION
  s.authors     = ["Bloom Developers"]
  s.email       = ["dev@bloom.solutions"]
  s.homepage    = "https://github.com/bloom-solutions/bloom_trade_client-rails"
  s.summary     = gem_description
  s.description = gem_description
  s.license     = "MIT"

  s.files = Dir[
    "{app,config,db,lib}/**/*",
    "MIT-LICENSE",
    "Rakefile",
    "README.md",
  ]

  if s.respond_to?(:metadata)
    s.metadata["allowed_push_host"] = "https://gem.fury.io"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  s.add_dependency "addressable", "~> 2.5"
  s.add_dependency "api_client_base", "~> 1.0"
  s.add_dependency "light-service", "0.11.0"
  s.add_dependency "loofah", ">= 2.2.3"
  s.add_dependency "message_bus_client_worker", ">= 1.0"
  s.add_dependency "rails", "~> 6.0"
  s.add_dependency "sidekiq", ">= 5.0"
  s.add_dependency "typhoeus", "~> 1.3"
  s.add_dependency "virtus", "~> 1.0"
  s.add_dependency "virtus-matchers"

  s.add_development_dependency "factory_bot_rails", "~> 4.11"
  s.add_development_dependency "fakeredis"
  s.add_development_dependency "pry"
  s.add_development_dependency "rspec-rails", "~> 5.0"
  s.add_development_dependency "rspec-sidekiq"
  s.add_development_dependency "sqlite3", "~> 1.3"
  s.add_development_dependency "stellar-sdk"
  s.add_development_dependency "timecop"
  s.add_development_dependency "vcr", "~> 4.0"
  s.add_development_dependency "wait"
  s.add_development_dependency "webmock", "~> 3.4"
end
