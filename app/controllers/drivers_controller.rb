# frozen_string_literal: true

class DriversController < ApplicationController
  def index
    drivers = Driver.limit(limit).offset(offset)
    render json: DriverSerializer.new(drivers, is_collection: true)
  end

  private def limit
    pagination_params[:limit] || 10
  end

  private def offset
    pagination_params[:offset] || 0
  end

  private def pagination_params
    params.permit(:limit, :offset)
  end
end
