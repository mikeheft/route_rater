# frozen_string_literal: true

class ApplicationController < ActionController::API
  private def pagination_params
    params.permit(:limit, :offset)
  end
  private def limit
    pagination_params[:limit] || 2
  end

  private def offset
    pagination_params[:offset] || 0
  end
end
