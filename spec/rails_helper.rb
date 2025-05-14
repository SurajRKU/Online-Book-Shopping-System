# spec/rails_helper.rb
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)


ENV['RAILS_ENV'] ||= 'test'

#require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
#RSpec.configure do |config|
#  config.include FactoryBot::Syntax::Methods
#end

RSpec.configure do |config|
  config.include ActionDispatch::TestProcess::FixtureFile
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

end