# frozen_string_literal: true

module Rides
  module Commands
    class ComputeAmount < BaseCommand
      BASE_PAY_AMOUNT = Money.new(12_00)
      MILEAGE_BONUS_AMOUNT = Money.new(1_50)
      MILEAGE_BONUS_CLIFF = 5.0
      DURATION_BONUS_AMOUNT = Money.new(0.7)
      DURATION_BONUS_CLIFF = 0.25

      def call(ride:)
        distance_bonus_amount = compute_distance_bonus(ride.distance_meters)
        duration_bonus_amount = compute_duration_bonus(ride.duration)

        BASE_PAY_AMOUNT + distance_bonus_amount + duration_bonus_amount
      end

      private def compute_distance_bonus(distance_meters)
        distance_in_miles = convert_distance_to_miles(distance_meters)
        amount = if distance_in_miles > MILEAGE_BONUS_CLIFF
          MILEAGE_BONUS_AMOUNT * (distance_in_miles - MILEAGE_BONUS_CLIFF)
        else
          0
        end
        Money.new(amount)
      end

      private def compute_duration_bonus(duration)
        duration_in_hours = convert_duration_to_hours(duration)
        amount = if duration_in_hours > DURATION_BONUS_CLIFF
          DURATION_BONUS_AMOUNT * (duration_in_hours - DURATION_BONUS_CLIFF)
        else
          0
        end
        Money.new(amount)
      end

      private def convert_distance_to_miles(distance_meters)
        # 1 mile = 1609.34 meters
        distance_meters / 1609.34
      end

      private def convert_duration_to_hours(duration)
        # Since there are 3,600 seconds in one hour, that's the conversion ratio used in the formula
        duration.to_f / 3600
      end
    end
  end
end
