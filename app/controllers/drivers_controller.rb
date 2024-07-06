# frozen_string_literal: true

class DriversController < ApplicationController
  def index
    @drivers = Driver.limit(pagination_params[:limit]).offset(pagination_params[:offset])
  end

  private def pagination_params
    params.permit(:limit, :offset)
  end
end
