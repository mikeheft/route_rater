# frozen_string_literal: true

module Rides
  module Commands
    # Computes the duration of the commute for the ride.
    # This is used in the ranking for the rides that the driver will
    # choose from.
    # Returns a list of objects where the origin is the driver's current address(home)
    class GetCommuteDuration < BaseCommand
      def call(rides:, driver:)
        converted_rides_for_commute = convert_rides(rides, driver)
        GetRoutesData.call(rides: converted_rides_for_commute)
      end

      # Converts the Driver's current home address and
      # the Ride#from_address into structs that can be used to
      # obtain the route information
      private def convert_rides(rides, driver)
        rides.each_with_object([]) do |ride, acc|
          acc << OpenStruct.new(origin_place_id: driver.origin_place_id, destination_place_id: ride.origin_place_id)
        end
      end
    end
  end
end
