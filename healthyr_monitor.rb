class HealthyrMonitor < Sinatra::Base
  configure do
    Application.establish_connection
  end

  get "/" do
    @database_queries = HealthyrEvent.slowest.database.limit(5)
    @view_templates = HealthyrEvent.slowest.view.limit(5)
    @controller_actions = HealthyrEvent.slowest.controller.limit(5)
    erb :index
  end

  get "/events" do
    content_type :json

    @database = HealthyrEvent.database.sort({reported_at: 1})
    @view = HealthyrEvent.view.sort({reported_at: 1})
    @controller = HealthyrEvent.controller.sort({reported_at: 1})

    database_times = {}
    @database.each do |event|
      time = event.reported_at.to_i
      total = event.time['total']
      if database_times[time]
        database_times[time] << total
      else
        database_times[time] = [total]
      end
    end

    view_times = {}
    @view.each do |event|
      time = event.reported_at.to_i
      total = event.time['total']
      if view_times[time]
        view_times[time] << total
      else
        view_times[time] = [total]
      end
    end

    controller_times = {}
    @controller.each do |event|
      time = event.reported_at.to_i
      total = event.time['total']
      if controller_times[time]
        controller_times[time] << total
      else
        controller_times[time] = [total]
      end
    end

    database = database_times.map {|time, values| [time, values.reduce(:+) / values.size.to_f] }
    view = view_times.map {|time, values| [time, values.reduce(:+) / values.size.to_f] }
    controller = controller_times.map {|time, values| [time, values.reduce(:+) / values.size.to_f] }

    {chartData: [database, view, controller]}.to_json
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
