class HealthyrEvent
  include Mongoid::Document

  field :instance_id, type: String
  field :name, type: String
  field :value, type: String
  field :reported_at, type: DateTime
  field :time, type: Hash

  scope :slowest, order_by("time.total" => -1)
  scope :database, where(name: "database")
  scope :view, where(name: "view")
  scope :controller, where(name: "controller")
end
