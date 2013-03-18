class HealthyrMonitor < Sinatra::Base
  configure do
    Application.establish_connection
  end

  get "/" do
    erb :index
  end

  get "/events" do
    content_type :json

    period = (params[:period].to_i || 15).minutes.ago

    slowest_stats = SlowestStat.new(
      HealthyrEvent.slowest.database.period(period).limit(5),
      HealthyrEvent.slowest.view.period(period).limit(5),
      HealthyrEvent.slowest.controller.period(period).limit(5)
    ).stats

    chart_data = ChartData.new(
      HealthyrEvent.database.period(period).sort({reported_at: 1}),
      HealthyrEvent.view.period(period).sort({reported_at: 1}),
      HealthyrEvent.controller.period(period).sort({reported_at: 1})
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
