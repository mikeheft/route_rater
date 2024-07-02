# frozen_string_literal: true

class Address < ApplicationRecord
  has_many :driver_addresses, dependent: :destroy
  has_many :ride_origins, class_name: "Ride", foreign_key: "from_address_id", dependent: nil, inverse_of: :from_address
  has_many :ride_destinations, class_name: "Ride", foreign_key: "to_address_id", dependent: nil, inverse_of: :to_address

  validates :line_1, :city, :state, :zip_code, :place_id, :latitude, :longitude, presence: true

  def rides
    Ride.by_address(id)
  end
end
