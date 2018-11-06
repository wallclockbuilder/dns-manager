FactoryBot.define do
  factory :record do
    name { Faker::StarWars.character }
    record_type { "NAME" }
    record_data { "www.rootdomain.com" }
    ttl { Faker::Number.number(3) }
  end
end
