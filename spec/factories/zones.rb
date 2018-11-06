FactoryBot.define do
  factory :zone do
    name { Faker::StarWars.character }

    # factory :zone_with_record do
    #   after(:create) do |zone|
    #     create(:record, zone: zone)
    #   end
    # end
    #
    # factory :zone_with_records do
    #     transient do
    #       records_count 10
    #     end
    #
    #     after(:create) do |zone, evaluator|
    #       create_list(:records, evaluator.records_count, zone: zone)
    #     end
    # end
  end
end
