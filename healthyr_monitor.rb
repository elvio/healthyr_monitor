class HealthyrMonitor < Sinatra::Base
  configure do
    Application.establish_connection
  end

  before do
    @period = (params[:period] || 15).to_i.minutes.ago
    @limit = (params[:limit] || 5).to_i
    @action = request.path_info.gsub("/", "")
  end

  get "/" do
    erb :index
  end

  get "/database" do
    erb :database
  end

  get "/view" do
    erb :view
  end

  get "/controller" do
    erb :controller
  end

  get "/events" do
    content_type :json

    if params[:filter]
      @filter = {params[:filter].to_sym => true}
    end

    slowest_stats = SlowestStat.new(
      HealthyrEvent.slowest.database.period(@period).limit(@limit),
      HealthyrEvent.slowest.view.period(@period).limit(@limit),
      HealthyrEvent.slowest.controller.period(@period).limit(@limit)
    ).stats

    chart_data = ChartData.new(
      HealthyrEvent.database.period(@period).sort({reported_at: 1}),
      HealthyrEvent.view.period(@period).sort({reported_at: 1}),
      HealthyrEvent.controller.period(@period).sort({reported_at: 1}),
      @filter
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
