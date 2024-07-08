# frozen_string_literal: true

require "./lib/api_exception/base_exception"

module Rides
  module Commands
    # Makes a request to the Google API to obtain the route information for all the
    # selectable rides for a given driver. We use the Route Matrix to ensure we are making as few calls
    # as possible. The Route Matrix returns all possible routes for the given origins/destinations.
    # Even though we only care about one combo per route, it is still more efficient to do it in this manner.
    # We then compare the indexes and get the ones that match, which gives us our original desired routes.
    class GetRoutesData < BaseCommand
      include Client::Helpers

      CACHE = Cache::Store
      DIRECTIONS_API_URL = "https://routes.googleapis.com/distanceMatrix/v2:computeRouteMatrix"
      DEFAULT_HEADERS = {
        "X-Goog-FieldMask" => "originIndex,destinationIndex,status,condition,distanceMeters,duration",
        "X-goog-api-key" => ENV["GOOGLE_API_KEY"],
        "Content-Type" => "application/json"
      }.freeze
      DEFAULT_REQUEST_PARAMS = { routingPreference: "TRAFFIC_AWARE", travelMode: "DRIVE" }.freeze
      MAX_NUM_ELEMENTS = 25

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
        data = data.flatten.select { _1[:originIndex] == _1[:destinationIndex] }
        if data.length != rides.length
          raise ApiException::RideCountMismatchError,
            "The number of routes does not match the number of rides.",
            500,
            :internal_error
        end

        data = transform_keys!(data)

        combine_routes_data!(data, rides)
      end

      # The manner in which jsonapi-serializer serialzies pojos,
      # in order to adhere to the json api spec, we need to define
      # the id _and_ the object iteself.
      private def combine_routes_data!(data, rides)
        data.map.with_index do |d, idx|
          ride = rides[idx]
          OpenStruct.new(ride_id: ride.id, from_address_id: ride.from_address&.id,
            from_address: ride.from_address, to_address: ride.to_address,
            to_address_id: ride.to_address&.id, **d)
        end
      end

      private def connection
        @connection ||= Client::Request.connection(
          url: DIRECTIONS_API_URL,
          headers: DEFAULT_HEADERS
        )
      end

      private def get_route_data_for_rides(rides)
        batches = rides.each_slice(MAX_NUM_ELEMENTS).to_a
        batches.map do |batch|
          body = build_request_body(batch)
          response_body = routes_data(body)
          JSON.parse(response_body, symbolize_names: true)
        end
      end

      private def routes_data(body)
        key = encrypt!(body)
        if cached?(key)
          get_cached_response(key)
        else
          fetch_routes_data(key, body)
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

      private def fetch_routes_data(key, body)
        response = with_retries do
          connection.post(
            DIRECTIONS_API_URL,
            body.merge(DEFAULT_REQUEST_PARAMS)
          )
        end

        handle_response(response, key)
      end

      private def handle_response(response, key)
        if response.status != 200
          result = JSON.parse(response.body, symbolize_names: true)
          error = result.first[:error]
          raise ApiException::HTTPRequestError.new(error[:message], error[:status].downcase.to_sym, error[:code])
        else
          body = response.body
          cache_response!(key, body)

          body
        end
      rescue JSON::ParserError => e
        message = e.message
        Rails.logger.warn "Attemped to parse invalid JSON: #{message}"
        raise ApiException::JSONParserError, message
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
