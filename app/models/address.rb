# frozen_string_literal: true

class Address < ApplicationRecord
  has_many :driver_addresses, dependent: :destroy
  has_many :ride_origins, class_name: "Ride", foreign_key: "from_address_id", dependent: nil, inverse_of: :from_address
  has_many :ride_destinations, class_name: "Ride", foreign_key: "to_address_id", dependent: nil, inverse_of: :to_address

  validates :line_1, :city, :state, :zip_code, :place_id, :latitude, :longitude, presence: true

  geocoded_by :full_address do |obj, results|
    if (geo = results.first)
      obj.latitude = geo.latitude
      obj.longitude = geo.longitude
      obj.place_id = geo.place_id
    end
  end

  before_validation :geocode,
    if: ->(obj) {
          obj.full_address.present? && %i[line_1 city state zip_code place_id latitude
                                          longitude].any? do
            obj.send("#{_1}_changed?")
          end
        }

  def full_address
    [line_1, line_2, city, state, zip_code].compact.join(", ")
  end

  def rides
    Ride.by_address(id)
  end
end
