class ChartData
  attr_accessor :database, :view, :controller

  def initialize(database, view, controller)
    @database = database
    @view = view
    @controller = controller
    @times = {}
  end

  def data
    [data_for(:database), data_for(:view), data_for(:controller)]
  end

  def options
  end

  private

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
