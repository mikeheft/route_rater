# frozen_string_literal: true

module Rides
  module Commands
    # Makes a request to the Google API to obtain the route information
    class GetRoutesData < BaseCommand
      CACHE = Cache::Store
      DIRECTIONS_API_URL = "https://routes.googleapis.com/distanceMatrix/v2:computeRouteMatrix"
      DEFAULT_HEADERS = {
        "X-Goog-FieldMask" => "originIndex,destinationIndex,status,condition,distanceMeters,duration",
        "X-goog-api-key" => ENV["GOOGLE_API_KEY"],
        "Content-Type" => "application/json"
      }.freeze
      DEFAULT_REQUEST_PARAMS = { routingPreference: "TRAFFIC_AWARE", travelMode: "DRIVE" }.freeze

      def call(rides:)
        data = get_route_data_for_rides(rides)
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

      private def get_route_data_for_rides(rides)
        body = build_request_body(rides)
        response_body = routes_data(body)
        JSON.parse(response_body, symbolize_names: true)
      end

      private def routes_data(body)
        key = encrypt!(body)
        if cached?(key)
          get_cached_response(key)
        else
          response = connection.post(
            DIRECTIONS_API_URL,
            body.merge(DEFAULT_REQUEST_PARAMS)
          )
          body = response.body
          cache_response!(key, body)

          body
        end
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

      private def cache_response!(key, value)
        CACHE.set(key, value)
      end

      private def get_cached_response(key)
        CACHE.get(key)
      end

      private def cached?(key)
        CACHE.exists?(key)
      end

      private def encrypt!(obj)
        Digest::SHA2.hexdigest(JSON.dump(obj))
      end
    end
  end
end
