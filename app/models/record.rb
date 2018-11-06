class Record < ApplicationRecord
  belongs_to :zone

  validates_presence_of :name
  validates_presence_of :record_type
  validates_presence_of :record_data
  validates_presence_of :ttl

  validate :record_type_valid_for_record_data?

  private

  def record_type_valid_for_record_data?
    # invalidates when record_type is CNAME but record_data is not a valid domain name
    valid_domain_name = /(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}\.?$)/
    if record_type == 'CNAME' && !record_data.match(valid_domain_name)
      errors.add(:base, "record_data must be a valid domain name when record_type is CNAME")
    end

  # invalidates when record type is A but record data is not an IPv4 address
    valid_ipv4_address = /^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
    if record_type =='A' && !record_data.match(valid_ipv4_address)
      errors.add(:base, "record_data must be a valid IPv4 address when record_type is A")
    end
  end
end
