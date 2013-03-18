require "spec_helper"

describe SlowestStat do
  def create_event(value, time)
    HealthyrEvent.new(value: value, time: time, reported_at: 1)
  end

  let(:sql) { "SELECT * FROM users" }
  let(:database_time) { Hash['total' => 10] }
  let(:database) { [ create_event(sql, database_time) ] }

  let(:view_path) { "users/index" }
  let(:view_time) { Hash['total' => 20] }
  let(:view) { [ create_event(view_path, view_time) ] }

  let(:action) { "UsersController#index" }
  let(:controller_time) { Hash['total' => 30, 'db' => '10', 'view' => 20] }
  let(:controller) { [create_event(action, controller_time)] }

  subject { SlowestStat.new(database, view, controller).stats }

  it "creates the stats" do
    subject.should == {
      database: [
        value: sql, time: database_time, reported_at: 1
      ],

      view: [
        value: view_path, time: view_time, reported_at: 1
      ],

      controller: [
        value: action, time: controller_time, reported_at: 1
      ]
    }
  end
end
