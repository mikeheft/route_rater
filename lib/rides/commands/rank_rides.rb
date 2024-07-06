# frozen_string_literal: true

module Rides
  module Commands
    class RankRides < BaseCommand
      def call(driver:)
        rank!(driver)
      end

      # How the Sorting Works
      #   1. Calculate the Key: For each ride, calculate the earnings per hour using rank_key.
      #   2. Negate the Key: By using -rank_key, we convert the highest earnings per hour to the smallest negative
      #       number, and the smallest earnings per hour to the largest negative number.
      #   3. Sort in Ascending Order: Ruby's sort_by method will then sort the rides based on these negative values,
      #       effectively putting the rides with the highest earnings per hour first.
      private def rank!(driver)
        rides = combined_ride_data(driver)
        return [] if rides.empty?

        rides.sort_by { |ride| -rank_key(ride) }
      end

      # (ride earnings) / (commute duration + ride duration)
      private def rank_key(ride)
        earnings = ride.ride_amount.amount
        ride_duration_hours = duration_to_hours(ride.duration)
        commute_duration_hours = duration_to_hours(ride.commute_duration)
        total_duration_hours = ride_duration_hours + commute_duration_hours

        # Earnings per hour
        earnings / total_duration_hours
      end

      private def duration_to_hours(duration)
        duration.to_i / 3600.0
      end

      # Once we get the data, we want to combine them into one struct
      # to more easily compute the ride earnings and assign a rank
      private def combined_ride_data(driver)
        commutes = commute_durations(driver)
        rides = route_data(driver)

        if commutes.count != rides.count
          raise RideCountMismatchError,
            "The number of rides doesn't match the number of commute rides." \
            "Please check the ride(s) configuration and try again."
        end

        rides.map.with_index do |ride, idx|
          commute = commutes.fetch(idx)
          commute_duration = commute.duration
          commute_distance = commute.distance_meters
          ride_amount = ComputeAmount.call(ride:)

          ride.commute_duration = commute_duration
          ride.commute_distance = commute_distance
          ride.ride_amount = ride_amount
          ride
        end
      end

      # Get the driving duration to the Ride#from_address,
      # to get the duration of the commute to start the ride
      private def commute_durations(driver)
        rides = selectable_rides_near_driver(driver)
        @commute_durations ||= GetCommuteDuration.call(rides:, driver:)
      end

      # Get route data for the ride, the duration and the distance between
      # the from and to addresses
      private def route_data(driver)
        rides = selectable_rides_near_driver(driver)
        @route_data ||= GetRoutesData.call(rides:)
      end

      private def selectable_rides_near_driver(driver)
        @selectable_rides_near_driver ||= Ride.selectable.nearby_driver(driver)
      end
    end
  end
end
