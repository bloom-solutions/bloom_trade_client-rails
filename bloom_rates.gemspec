$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bloom_rates/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bloom_rates-rails"
  s.version     = BloomRates::VERSION
  s.authors     = ["Ace Subido"]
  s.email       = ["ace.subido@gmail.com"]
  s.homepage    = "https://github.com/bloom-solutions/bloom_rates-rails"
  s.summary     = "Mountable Exchange Rates client for Bloom applications"
  s.description = "Mountable Exchange Rates client for Bloom applications"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  if s.respond_to?(:metadata)
    s.metadata["allowed_push_host"] = "https://gem.fury.io"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  s.add_dependency "gem_config"
  s.add_dependency "httparty", "0.15.6"
  s.add_dependency "light-service"
  s.add_dependency "message_bus-client"
  s.add_dependency "rails", "~> 5.2.0"
  s.add_dependency "virtus"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "pry"
  s.add_development_dependency "factory_bot_rails"
  s.add_development_dependency "webmock"
end
