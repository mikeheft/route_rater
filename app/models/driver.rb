# frozen_string_literal: true

class Driver < ApplicationRecord
  has_many :driver_addresses, dependent: :destroy
  has_one :current_driver_address,
    -> { where(current: true) },
    class_name: "DriverAddress",
    dependent: :destroy,
    inverse_of: :driver
  has_one :current_address, through: :current_driver_address, source: :address, dependent: :destroy

  validates :first_name, :last_name, presence: true
end
