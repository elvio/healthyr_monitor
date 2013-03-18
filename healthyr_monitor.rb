class HealthyrMonitor < Sinatra::Base
  configure do
    Application.establish_connection
  end

  get "/" do
    erb :index
  end

  get "/events" do
    content_type :json

    slowest_stats = SlowestStat.new(
      HealthyrEvent.slowest.database.limit(5),
      HealthyrEvent.slowest.view.limit(5),
      HealthyrEvent.slowest.controller.limit(5)
    ).stats

    chart_data = ChartData.new(
      HealthyrEvent.database.sort({reported_at: 1}),
      HealthyrEvent.view.sort({reported_at: 1}),
      HealthyrEvent.controller.sort({reported_at: 1})
    ).data

    {
      chartData: chart_data,
      slowestStats: slowest_stats
    }.to_json
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
