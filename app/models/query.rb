class Query < ApplicationRecord
  has_one :user_location, :dependent => :destroy
  has_one :gas_station, :through => :user_location, :dependent => :destroy
  reverse_geocoded_by :latitude, :longitude

  # google map has a range of latitdue which is about [-85, 85]
  validates :latitude, presence: true, numericality: {greater_than_or_equal_to: -85, less_than_or_equal_to: 85}
  validates :longitude, presence: true, numericality: {greater_than_or_equal_to: -180, less_than_or_equal_to: 180}
end
