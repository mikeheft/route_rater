# frozen_string_literal: true

module Drivers
  class DriversController < ApplicationController
    def index
      drivers = Driver.limit(limit).offset(offset)
      render json: DriverSerializer.new(drivers, is_collection: true)
    end

    private def pagination_params
      params.permit(:limit, :offset)
    end
  end
end
