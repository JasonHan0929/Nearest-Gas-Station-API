require 'rails_helper'

RSpec.describe Query, type: :model do
  it { should have_one(:user_location).dependent(:destroy) }
  it { should validate_presence_of(:longitude) }
  it { should validate_presence_of(:latitude) }
  it { should validate_numericality_of(:longitude) }
  it { should validate_numericality_of(:latitude) }

end
