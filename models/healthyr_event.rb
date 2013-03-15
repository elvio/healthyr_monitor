class HealthyrEvent
  include Mongoid::Document

  field :instance_id, type: String
  field :name, type: String
  field :value, type: String
  field :reported_at, type: DateTime
  field :time, type: Hash
end
