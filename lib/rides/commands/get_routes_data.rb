# frozen_string_literal: true

module Rides
  module Commands
    # Makes a request to the Google API to obtain the route information
    class GetRoutesData < BaseCommand
      DIRECTIONS_API_URL = "https://routes.googleapis.com/distanceMatrix/v2:computeRouteMatrix"
      DEFAULT_HEADERS = {
        "X-Goog-FieldMask" => "originIndex,destinationIndex,status,condition,distanceMeters,duration",
        "X-goog-api-key" => ENV["GOOGLE_API_KEY"],
        "Content-Type" => "application/json"
      }.freeze
      DEFAULT_REQUEST_PARAMS = { routingPreference: "TRAFFIC_AWARE", travelMode: "DRIVE" }.freeze

      def call(rides:)
        data = get_direction_data_for_ride(rides)
        results(data, rides)
      end

      # Returns a list of objects, with attributes of
      # @param[:distance_meters] = Integer
      # @param[:duration] = String, e.g., "577s"
      # Duration is in seconds
      private def results(data, rides)
        # The response keeps the array positioning on the return. Since we're getting a matrix
        # of routes back, we only want the ones where we explicitly have a 'Ride'. This means that
        # we want the computations where the indicies match.
        data = data.select { _1[:originIndex] == _1[:destinationIndex] }
        data = transform_keys!(data)

        data.map.with_index { OpenStruct.new(ride: rides[_2], **_1) }
      end

      private def connection
        @connection ||= Client::Request.connection(
          url: DIRECTIONS_API_URL,
          headers: DEFAULT_HEADERS
        )
      end

      private def get_direction_data_for_ride(rides)
        body = build_request_body(rides)

        response = connection.post(
          DIRECTIONS_API_URL,
          body.merge(routingPreference: "TRAFFIC_AWARE", travelMode: "DRIVE")
        )

        JSON.parse(response.body, symbolize_names: true)
      end

      private def build_request_body(rides)
        rides.each_with_object({}) do |ride, acc|
          acc[:origins] ||= []
          acc[:destinations] ||= []

          acc[:origins] << { waypoint: { placeId: ride.origin_place_id } }
          acc[:destinations] << { waypoint: { placeId: ride.destination_place_id } }
        end
      end

      private def transform_keys!(data)
        data.map { |d| d.transform_keys { |k| k.to_s.underscore.to_sym } }
      end
    end
  end
end
