# frozen_string_literal: true

class Address < ApplicationRecord
  has_many :driver_addresses, dependent: :destroy

  validates :line_1, :city, :state, :zip_code, :place_id, :latitude, :longitude, presence: true
end
