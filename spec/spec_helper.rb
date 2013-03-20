$: << File.join(File.dirname(__FILE__), "../")

ENV["RACK_ENV"] = "test"

require "application"
require "healthyr_monitor"
require "rack/test"

RSpec.configure do |c|
  c.include Rack::Test::Methods

  c.before(:each) do
    HealthyrEvent.delete_all
  end
end
