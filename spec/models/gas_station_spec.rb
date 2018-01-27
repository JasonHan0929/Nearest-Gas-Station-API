require 'rails_helper'

RSpec.describe GasStation, type: :model do
  it { should belong_to(:user_location) }
  it { should validate_presence_of(:street_address) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:state) }
  it { should validate_presence_of(:postal_code) }
end
