# frozen_string_literal: true

class Address < ApplicationRecord
  has_many :driver_addresses, dependent: :destroy
  has_one :current_driver_address, -> { where(current: true) }, class_name: "DriverAddress", dependent: :destroy
  has_one :current_driver, through: :current_driver_address, source: :address, dependent: :destroy

  validates :line_1, :city, :state, :zip_code, :place_id, :latitude, :longitude, presence: true
end
