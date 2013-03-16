require 'spec_helper'

describe "HealthyrEvent" do
  describe ".slowest" do
    it "sorts by the slowest events" do
      event1 = HealthyrEvent.create(time: {total: 10})
      event2 = HealthyrEvent.create(time: {total: 15})
      event3 = HealthyrEvent.create(time: {total: 16})

      HealthyrEvent.slowest.should == [event3, event2, event1]
    end
  end

  describe "scopes by name" do
    let(:database)   { HealthyrEvent.create(name: "database") }
    let(:view)       { HealthyrEvent.create(name: "view") }
    let(:controller) { HealthyrEvent.create(name: "controller") }

    before do
      database && view && controller
    end

    describe ".database" do
      subject { HealthyrEvent.database }
      it { should == [database] }
    end

    describe ".view" do
      subject { HealthyrEvent.view }
      it { should == [view] }
    end

    describe ".controller" do
      subject { HealthyrEvent.controller }
      it { should == [controller] }
    end
  end
end
