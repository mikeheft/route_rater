# frozen_string_literal: true

module Rides
  module Commands
    class GetDirectionData < BaseCommand
      DIRECTIONS_API_URL = "https://routes.googleapis.com/directions"
      COMPUTE_ROUTES_URL = "/v2:computeRoutes"
      DEFAULT_HEADERS = {
        "X-Goog-FieldMask" => "routes.distanceMeters,routes.duration",
        "X-goog-api-key" => ENV["GOOGLE_API_KEY"],
        "Content-Type" => "application/json"
      }.freeze

      def call(ride:)
        data = get_direction_data_for_ride(ride)
      end

      private def connection
        @connection ||= Client::Request.connection(
          url: DIRECTIONS_API_URL,
          headers: DEFAULT_HEADERS
        )
      end

      private def get_direction_data_for_ride(ride)
        to_address = ride.to_address
        from_address = ride.from_address
        body = {
          origin: { placeId: from_address.place_id }, destination: { placeId: to_address.place_id },
          routingPreference: "TRAFFIC_AWARE", travelMode: "DRIVE"
        }

        connection.post(DIRECTIONS_API_URL + COMPUTE_ROUTES_URL, body)
      end
    end
  end
end
