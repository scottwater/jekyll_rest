require "rspec"
require "rack/test"
require "webmock/rspec"
require "./environment.rb"

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
