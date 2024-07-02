# frozen_string_literal: true

class Ride < ApplicationRecord
  belongs_to :driver, optional: true
  belongs_to :from_address, class_name: "Address"
  belongs_to :to_address, class_name: "Address"

  validates :duration, :distance, :commute_duration, :amount_cents, presence: true
  monetize :amount_cents,
    as: :amount,
    allow_nil: false,
    numericality: {
      greater_than_or_equal_to: 0
    }

  scope :by_address, ->(address_id) {
                       where(from_address_id: address_id).or(where(to_address_id: address_id))
                     }
end
