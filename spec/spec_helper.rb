ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../dummy/config/environment", __FILE__)

if Rails.env.production?
  abort("The Rails environment is running in production mode!")
end

require "fakeredis"
require "pry"
require "rspec/rails"
require "rspec-sidekiq"
require "stellar-sdk"
require "wait"
require "timecop"
require "webmock/rspec"
require "virtus/matchers/rspec"

Dir[BloomTradeClient::Engine.root.join("spec/support/**/*.rb")].each do |f|
  require f
end

SPEC_DIR = Pathname.new(File.dirname(__FILE__))
CONFIG = YAML.load_file(SPEC_DIR.join("config.yml"))
  .with_indifferent_access

FIXTURES_DIR = SPEC_DIR.join("fixtures")

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.before :each do |c|
    Sidekiq::Testing.inline!
  end
end
