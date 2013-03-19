class ChartData
  attr_accessor :database, :view, :controller

  def initialize(database, view, controller, filters = nil)
    @database = database
    @view = view
    @controller = controller
    @times = {}
    @filters = filters
  end

  def data
    if filtering?
      [].tap do |d|
        d << data_for(:database)   if @filters[:database]
        d << data_for(:view)       if @filters[:view]
        d << data_for(:controller) if @filters[:controller]
      end
    else
      [:database, :view, :controller].map {|t| data_for(t)}
    end
  end

  private

  def filtering?
    @filters.kind_of?(Hash)
  end

  def data_for(type)
    {
      label: type.to_s,
      data: average_by_time(type)
    }
  end

  def average_by_time(type)
    @times[type] = {}
    send(type).each do |event|
      time = event.reported_at.to_i * 1000
      total = event.time['total']
      if @times[type][time]
        @times[type][time] << total
      else
        @times[type][time] = [total]
      end
    end

    @times[type].map {|time, values| [time, values.reduce(:+) / values.size.to_f] }
  end
end
