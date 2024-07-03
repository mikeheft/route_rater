# frozen_string_literal: true

module Rides
  module Commands
    class GetDirectionData < BaseCommand
      COMPUTE_ROUTES_URL = "/v2:computeRoutes"
      DEFAULT_HEADERS = { "X-Goog-FieldMask" => "routes.distanceMeters,routes.duration" }.freeze
      DEFAULT_PARAMS =  { key: ENV["GOOGLE_API_KEY"], routingPreference: "TRAFFIC_AWARE", travelMode: "DRIVE" }.freeze

      def call(ride)
        data = get_direction_data_for_ride(ride)
      end

      private def connection
        @connection ||= Client::Request.connection(
          DIRECTIONS_API_URL,
          DEFAULT_PARAMS,
          DEFAULT_HEADERS
        )
      end

      private def get_direction_data_for_ride(ride)
        to_address = ride.to_address
        from_address = ride.from_address

        connection.get(COMPUTE_ROUTES_URL)
      end
    end
  end
end
