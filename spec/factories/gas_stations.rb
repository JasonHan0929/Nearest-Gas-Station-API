FactoryGirl.define do
  factory :gas_station do
    street_address{ Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    postal_code { Faker::Address.postcode }
    user_location_id nil
  end
end