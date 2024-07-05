# frozen_string_literal: true

class Ride < ApplicationRecord
  belongs_to :driver, optional: true
  belongs_to :from_address, class_name: "Address"
  belongs_to :to_address, class_name: "Address"

  validates :duration, :distance, :commute_duration, :amount_cents, presence: true, on: :update, if: :should_validate?
  monetize :amount_cents,
    as: :amount,
    allow_nil: false,
    numericality: {
      greater_than_or_equal_to: 0
    }

  scope :by_address, ->(address_id) {
    where(from_address_id: address_id).or(where(to_address_id: address_id))
  }

  scope :selectable, -> {
    includes(:from_address, :to_address)
      .select(:id, :from_address_id, :to_address_id)
      .where(driver_id: nil, duration: nil, distance: nil, commute_duration: nil, amount_cents: 0)
  }

  scope :nearby_driver, ->(driver) {
    current_driver_address = driver.current_address
    # Due to the manner in which Geocoder computes and orders this, we need to first
    # get the addresses within the driver's desired radius and _then_ find the rides
    # with corresponding from_address_id
    addresses = Address.where.not(id: current_driver_address.id)
      .near([current_driver_address.latitude, current_driver_address.longitude], driver.max_radius)
    binding.pry
    selectable.where(id: addresses.map(&:id))
  }

  def origin_place_id
    from_address.place_id
  end

  def destination_place_id
    to_address.place_id
  end

  private def should_validate?
    duration.present? && distance.present? && commute_duration.present? && amount_cents.present?
  end
end
