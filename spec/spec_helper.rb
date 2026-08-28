require 'simplecov'
SimpleCov.start do
  skip '/spec/'
  # Named rather than left to whatever got loaded: a file nothing exercises is the point
  cover 'lib/**/*.rb'
  # Read by the gemspec, which Bundler evaluates before this line runs, and it holds a constant
  skip 'lib/company/version.rb'
end
SimpleCov.minimum_coverage 100

require 'company'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on 'Module' and 'main'
  config.disable_monkey_patching!

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
end
