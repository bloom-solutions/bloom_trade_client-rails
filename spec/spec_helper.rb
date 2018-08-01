ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../dummy/config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require "pry"
require "rspec/rails"
require "webmock/rspec"

Dir[BloomRates::Engine.root.join('spec/support/**/*.rb')].each do |f|
  require f
end

SPEC_DIR = Pathname.new(File.dirname(__FILE__))
CONFIG = YAML.load_file(SPEC_DIR.join("config.yml")).
  with_indifferent_access

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
