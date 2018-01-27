require 'rails_helper'

RSpec.describe UserLocation, type: :model do
  it { should have_one(:gas_station).dependent(:destroy) }
  it { should belong_to(:query) }
  it { should validate_presence_of(:street_address) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:state) }
  it { should validate_presence_of(:postal_code) }
end
