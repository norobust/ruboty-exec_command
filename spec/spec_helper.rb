require "simplecov"
SimpleCov.start

ENV["RUBOTY_ENV"] = "test"

if ENV["CI"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require "active_support/core_ext/string/strip"
require "ruboty"
require "ruboty/exec_command"

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
