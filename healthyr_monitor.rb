class HealthyrMonitor < Sinatra::Base
  configure do
    Mongoid.load!(APP_ROOT.join("config/mongoid.yml"), settings.environment)
  end
end
