# frozen_string_literal: true

module Drivers
  class RidesController < ApplicationController
    def index
      rides = paginated_rides
      render json: RideSerializer.new(rides)
    end

    private def paginated_rides
      Rides::Commands::RankRides.call(driver:)[offset, limit]
    end

    private def driver
      @driver ||= Driver.find(ride_params[:driver_id])
    end

    private def ride_params
      params.permit(:driver_id, :limit, :offset)
    end
  end
end