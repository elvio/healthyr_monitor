class SlowestStat
  attr_accessor :database, :view, :controller

  def initialize(database, view, controller)
    @database = database
    @view = view
    @controller = controller
  end

  def stats
    {
      database: create_stats_for(:database),
      view: create_stats_for(:view),
      controller: create_stats_for(:controller)
    }
  end

  private

  def create_stats_for(type)
    send(type).map {|event| Hash[value: event.value, time: event.time, reported_at: event.reported_at] }
  end
end
