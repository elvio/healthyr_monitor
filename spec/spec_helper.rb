$: << File.join(File.dirname(__FILE__), "../")

require "application"
require "healthyr_monitor"
require "rack/test"

ENV["RACK_ENV"] = "test"

RSpec.configure do |c|
  c.include Rack::Test::Methods

  c.before(:each) do
    HealthyrEvent.delete_all
  end
end
