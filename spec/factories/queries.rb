FactoryGirl.define do
  factory :query do
    longitude { Faker::Address.longitude }
    latitude { Faker::Number.between(-85, 85) }
  end
end