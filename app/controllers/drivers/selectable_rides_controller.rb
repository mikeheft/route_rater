# frozen_string_literal: true

module Drivers
  class SelectableRidesController < ApplicationController
    def index
      rides = Rides::Commands::RankRides.call(driver:)[offset, limit]
      opts = { include: %i[from_address to_address] }
      render json: RidePojoSerializer.new(rides, opts)
    end

    private def driver
      @driver ||= Driver.find(ride_params[:driver_id])
    end

    private def ride_params
      params.permit(:driver_id, :limit, :offset)
    end
  end
end
