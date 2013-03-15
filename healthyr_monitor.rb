class HealthyrMonitor < Sinatra::Base
  configure do
    Application.establish_connection
  end

  post "/events" do
    data = JSON.parse(params['data'])
    from = data['from']
    events = data['events']

    events.each do |event|
      event.merge!('instance_id' => from)
      HealthyrEvent.create(event)
    end
  end
end
