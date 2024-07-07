# frozen_string_literal: true

module Drivers
  class RideController < ApplicationController
    def create;end

    private def ride_params
      params.permit(:driver_id, :ride_id, :duration, :distance, :amount)
    end
  end
end
