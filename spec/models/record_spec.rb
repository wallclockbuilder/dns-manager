require 'rails_helper'

RSpec.describe Record, type: :model do

  # Association tests
  # record belongs to a Zone
  it { should belong_to(:zone) }
  # Validation tests
  # record should have name, record_type, record_data, ttl before saving
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:record_type) }
  it { should validate_presence_of(:record_data) }
  it { should validate_presence_of(:ttl) }

  it 'invalidates when record_type is CNAME but record_data is not a valid domain name' do
    rec = Record.new(name: '@truezone', record_type: 'CNAME', record_data: '198.23.4.1', ttl: 81 )
    expect(rec).to be_invalid
    expect(rec.errors[:base]).to include('record_data must be a valid domain name when record_type is CNAME')
  end
  it 'invalidates when record_type is A but record_data is not an IPv4 address' do
    rec = Record.new(name: '@truzone.com' , record_type: 'A', record_data: 'www.truezone.com', ttl: 81 )
    expect(rec).to be_invalid
    expect(rec.errors[:base]).to include('record_data must be a valid IPv4 address when record_type is A')
  end

  it 'validates when record_type is A and record_data is valid ipv4 address' do
    rec = Record.new(name: '@truezone.com', record_type: 'A', record_data: '192.168.1.255', ttl: 81)
    expect(rec).to be_valid
  end

  it 'validates when record_type is CNAME and record_data is a valid domain name' do
    rec = Record.new(name: '@truezone', record_type: 'CNAME', record_data: 'www.truezone.com', ttl: 81 )
    expect(rec).to be_valid
  end
end
