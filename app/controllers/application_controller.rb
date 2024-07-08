# frozen_string_literal: true

# rubocop:disable Lint/RedundantSafeNavigation
class ApplicationController < ActionController::API
  # include ApiException::ErrorMapper

  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rescue_from StandardError, with: :handle_standard_error
  # rescue_from ApiException::BaseException, with: :render_error_response

  private def pagination_params
    params.permit(:limit, :offset)
  end
  private def limit
    pagination_params[:limit]&.to_i || 2
  end

  private def offset
    pagination_params[:offset]&.to_i || 0
  end

  # private def record_not_found(error)
  #   binding.pry
  #   raise NotFoundError, error.message, 404, :not_found
  # end

  # private def handle_standard_error(error)
  #   error_class = map_error(error)
  #   binding.pry
  #   raise error_class, error.message
  # rescue ApiException::BaseException => e
  #   binding.pry
  #   render_error_response(e)
  # end

  # private def render_error_response(error)
  #   render json: error, serializer: ApiExceptionSerializer, status: error.status
  # end
end
# rubocop:enable Lint/RedundantSafeNavigation
