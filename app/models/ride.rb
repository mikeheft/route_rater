# frozen_string_literal: true

class Ride < ApplicationRecord
  belongs_to :driver, optional: true

  validates :duration, :distance, :commute_duration, :amount_cents, presence: true
  monetize :amount_cents,
    as: :amount,
    allow_nil: false,
    numericality: {
      greater_than_or_equal_to: 0
    }
end
