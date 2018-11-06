class Zone < ApplicationRecord
  #model association
  has_many :records, dependent: :destroy

  # model validation
  validates_presence_of :name
  # validates_presence_of :records
end
