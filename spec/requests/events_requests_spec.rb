require "spec_helper"

describe 'events requests' do
  def app
    HealthyrMonitor
  end

  describe "POST /events" do
    let(:instance_id) { "host-222" }
    let(:time) { Hash['total' => 10] }
    let(:event_name) { "database" }
    let(:event_value) { "SELECT * FROM users" }
    let(:json) do
      {from: instance_id, events: [{name: event_name, value: event_value, time: time}]}.to_json
    end

    it "creates a new event" do
      post "/events", data: json

      HealthyrEvent.last.tap do |event|
        event.name.should        == event_name
        event.value.should       == event_value
        event.time.should        == time
        event.instance_id.should == instance_id
      end
    end
  end
end
