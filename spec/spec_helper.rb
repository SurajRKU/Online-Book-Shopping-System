# spec/spec_helper.rb
require File.expand_path("../../config/environment", __FILE__)


RSpec.configure do |config|
  config.include ActionDispatch::TestProcess::FixtureFile
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end