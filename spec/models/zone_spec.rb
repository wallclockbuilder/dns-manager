require 'rails_helper'

RSpec.describe Zone, type: :model do
  # Association tests
  # one zone has many records
  it { should have_many(:records).dependent(:destroy) }
  # Validation tests
  # zone table should have name and records
  it { should validate_presence_of(:name) }
  # it { should validate_presence_of(:records)}
  # Has a name, which must be a valid domain name

end
