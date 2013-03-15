require "rubygems"
require "bundler/setup"

require "json"
require "sinatra"
require "mongoid"

require "./models/healthyr_event"

APP_ROOT = Pathname.new(File.dirname(__FILE__))
LOGGER = Logger.new(APP_ROOT.join("healthyr.log"))

class Application
  def self.establish_connection
    Mongoid.load!(APP_ROOT.join("config/mongoid.yml"), ENV["RACK_ENV"] || "development")
  end
end
