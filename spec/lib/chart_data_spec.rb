require "spec_helper"

describe ChartData do
  let(:database) { [HealthyrEvent.new(time: {'total' => 2}, reported_at: 1), HealthyrEvent.new(time: {'total' => 6}, reported_at: 1)] }
  let(:view) { [HealthyrEvent.new(time: {'total' => 10}, reported_at: 1), HealthyrEvent.new(time: {'total' => 2}, reported_at: 1)] }
  let(:controller) { [HealthyrEvent.new(time: {'total' => 10}, reported_at: 1), HealthyrEvent.new(time: {'total' => 20}, reported_at: 1)] }

  subject { ChartData.new(database, view, controller).data }

  it "creates the chart data" do
    subject.should == [
      {label: "database", data: [[1, 4.0]]},
      {label: "view", data: [[1, 6.0]]},
      {label: "controller", data: [[1, 15.0]]}
    ]
  end
end
