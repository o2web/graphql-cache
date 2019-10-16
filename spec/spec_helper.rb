require 'bundler/setup'
require 'pry'
require 'promise'

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require 'graphql/cache'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    GraphQL::Cache.cache  = TestCache.new
    GraphQL::Cache.logger = TestLogger.new

    DB.logger = GraphQL::Cache.logger
  end

  # required after GraphQL::Cache initialization because dev
  # schema uses cache and logger objects from it.
  require_relative '../test_schema'

  config.include TestMacros
  config.extend  TestMacros::ClassMethods
end
