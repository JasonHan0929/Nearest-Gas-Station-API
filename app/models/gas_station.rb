class GasStation < ApplicationRecord
  belongs_to :user_location

  validates_presence_of :street_address, :city, :state, :postal_code
end
