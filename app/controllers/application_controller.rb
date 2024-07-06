# frozen_string_literal: true

class ApplicationController < ActionController::API
  private def limit
    pagination_params[:limit]&.to_i || 2
  end

  private def offset
    pagination_params[:offset]&.to_i || 0
  end
end
