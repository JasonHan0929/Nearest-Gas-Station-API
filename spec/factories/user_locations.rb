FactoryGirl.define do
  factory :user_location do
    street_address{ Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    postal_code { Faker::Address.postcode }
    query_id nil
  end
end