class UserLocation < ApplicationRecord
  belongs_to :query
  has_one :gas_station, dependent: :destroy

  validates_presence_of :street_address, :city, :state, :postal_code
end
